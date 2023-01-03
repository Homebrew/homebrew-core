class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.14.4",
      revision: "cd535263c1ad65fd03869591a8bd706680cbf04b"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6eacdf5ab5af87531f524ebb76041a3b0c76650d42a9b4f2e03c1b3052c179fc"
    sha256 cellar: :any,                 arm64_monterey: "e64d680f4b54f504950db8d659a9faf40a0b72aa30f00fb6163254f4993411bf"
    sha256 cellar: :any,                 arm64_big_sur:  "3fc2def0ca38a41c7a76e667dac6e7883043c53779a3144974a91458b45044fd"
    sha256 cellar: :any,                 ventura:        "30edda87d23af1d6c0fd46e20d93b913b2a4c6364ca1cd5de62d6958fa942f30"
    sha256 cellar: :any,                 monterey:       "ab44347034accd4db2faa0a0436f8c145b99086ad1519a02535ab1c2c143d18f"
    sha256 cellar: :any,                 big_sur:        "66ded4f517519967111e3ecac2b07fae90e5469d1a6f4c1b1dc6598092f22683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98fc7aa8fe2bba62577a5256d244d4fdfff28f99867e0865b0544729afbc3c2b"
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
        ln_sf (Formula["sdl2"].opt_lib/"libSDL2-2.0.0.dylib").relative_path_from(app_frameworks), app_frameworks
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
      assert_predicate app_frameworks/"libSDL2-2.0.0.dylib", :exist?, "Broken linkage with `sdl2`"
    end
  end
end
