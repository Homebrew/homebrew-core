class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.15.4",
      revision: "9a80120dc09997e40c0a73fda05c3e07a347259f"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7b7e1640343a34f3b98a9215e8b26709f5d3539dbfc841e002d3866dd098ae2"
    sha256 cellar: :any,                 arm64_ventura:  "c3037b0cdec874f62f9035e6606a2891d0c3aa21722e2c91e43d94951d04360c"
    sha256 cellar: :any,                 arm64_monterey: "b78305fdbc3f1b59e46fe9465c3b2744cca8498d963761a85da8cedfd3488388"
    sha256 cellar: :any,                 arm64_big_sur:  "be8822b3d4e89aa7837e7832284045a591da27694c713ed0e69debe0ee217f3c"
    sha256 cellar: :any,                 sonoma:         "b59c52218d5725e8c2395f1511e28053d4848f7e3efcdaa09daa9c9377478f6c"
    sha256 cellar: :any,                 ventura:        "e488ae0f8b2fcce83e24dcfdd08655edc896ce67a0cf66096ed8d7afc7ef7790"
    sha256 cellar: :any,                 monterey:       "ae96bf1d88b8c65df7383fe2019e063bb2dc8e2faf102f3fa343d84b0880f5fb"
    sha256 cellar: :any,                 big_sur:        "1f356b1c681265c7e438e331378f08ac482534a47a6ed634b3c280be8ca68c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff145a38da235b4ad92553594e935da3a8b019abeb1cfa069a638a67a7c8be46"
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
