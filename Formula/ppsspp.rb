class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.13.1",
      revision: "5083b206365a226fb51288e09424f8f5f5a3392a"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0f56c1b7d8006f006dcb52fa17da1dac70eb75b579f7ef4747720b444b55ab59"
    sha256 cellar: :any,                 arm64_big_sur:  "675c479f19ef32ee316d7e40a46794d1892e59a39e0d0a4a2b2393864e97286b"
    sha256 cellar: :any,                 monterey:       "25beafe716d6c84433141371a42ba7676d4a35262d3ca8963a62d605ac78eccf"
    sha256 cellar: :any,                 big_sur:        "ca2231ca179fb88fa754e56dfc4cab9057edc2df4e040ffd0234ae79393fd740"
    sha256 cellar: :any,                 catalina:       "784525d911a61aeb88364eb2b73db2e947448d204c37e29d0b2a7aa3d9b4c802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd91c2958904e972ed4969072265bde06c9ec6a61ed44c6f87ba092eefe4c05e"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
