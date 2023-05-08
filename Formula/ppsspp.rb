class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.15.3",
      revision: "6d619201bdd6d46a3e3d4b2a82a00148eb9ebc5a"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c71a1284ab98893487f0ebe3830b1bb3ed2586aff78434b6ffa864fb106d1f8"
    sha256 cellar: :any,                 arm64_monterey: "e6658ce223beb8fa2511c5dd0c59e69dadff9090c3368fdd8cdee9988ee12f3b"
    sha256 cellar: :any,                 arm64_big_sur:  "24a31ea25215c02718f3d517431d6e15e408c5743680a401046d896cbbc92069"
    sha256 cellar: :any,                 ventura:        "df24f41c86b76d451fcb147c33ad784868634951bbbc34794696943c9697fe4d"
    sha256 cellar: :any,                 monterey:       "e8e24c4ff72f8e419fe01ab05d5c93c3f7cbc30f56805325675e21df229a6e9a"
    sha256 cellar: :any,                 big_sur:        "0ce90071ceb3a6adf770cd941599e86c0a5c617bea95986b7f99db5cf9ee249d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32510ff7e55572172f12fccdbf19b969cd907b8ca3412b2a39f6c1e52c3dde96"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "glew"
  end

  on_intel do
    # ARM uses a bundled, unreleased libpng.
    # Make unconditional when we have libpng 1.7.
    depends_on "libpng"
  end

  def install
    # Build PPSSPP-bundled ffmpeg from source. Changes in more recent
    # versions in ffmpeg make it unsuitable for use with PPSSPP, so
    # upstream ships a modified version of ffmpeg 3.
    # See https://github.com/Homebrew/homebrew-core/issues/84737.
    cd "ffmpeg" do
      if OS.mac?
        rm_rf "macosx"
        system "./mac-build.sh"
      else
        rm_rf "linux"
        system "./linux_x86-64.sh"
      end
    end

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    (vulkan_frameworks/"libMoltenVK.dylib").unlink
    vulkan_frameworks.install_symlink Formula["molten-vk"].opt_lib/"libMoltenVK.dylib"

    mkdir "build" do
      args = std_cmake_args + %w[
        -DUSE_SYSTEM_LIBZIP=ON
        -DUSE_SYSTEM_SNAPPY=ON
        -DUSE_SYSTEM_LIBSDL2=ON
        -DUSE_SYSTEM_LIBPNG=ON
        -DUSE_SYSTEM_ZSTD=ON
        -DUSE_SYSTEM_MINIUPNPC=ON
      ]

      system "cmake", "..", *args
      system "make"

      if OS.mac?
        prefix.install "PPSSPPSDL.app"
        bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
        mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"

        # Replace app bundles with symlinks to allow dependencies to be updated
        app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
        ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
      else
        bin.install "PPSSPPSDL" => "ppsspp"
      end
    end
  end

  test do
    system "#{bin}/ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_predicate app_frameworks/"libMoltenVK.dylib", :exist?, "Broken linkage with `molten-vk`"
    end
  end
end
