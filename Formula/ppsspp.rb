class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.13.2",
      revision: "9fe6338e3bf397f8a009a51a282c139dfa180eb6"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5d42c30cbad8d7eb332aa520d07832bc8026fa32705be36a220e2fab82af317"
    sha256 cellar: :any,                 arm64_monterey: "13bffd8ebd5acc25e6be6747fc2fa7a99582cecab7b2085bcff4ebba8109c63c"
    sha256 cellar: :any,                 arm64_big_sur:  "468aa96721c46a7051f1903b08c58b1eb4ab11d9db483eabf4a9aba17218d941"
    sha256 cellar: :any,                 ventura:        "ec8b33a154ee0695f0132975e7416d6b9fb4cac85c92271d75e2446ae5155edc"
    sha256 cellar: :any,                 monterey:       "3e9a5da2560205a7afa1715c3d635949013efe6e950ac19ad8417685cff782dd"
    sha256 cellar: :any,                 big_sur:        "6f7bf991ba10cc703fc083dd646533ceaf7aff54df3cc69570b08b1503eda67c"
    sha256 cellar: :any,                 catalina:       "6b009ff1ab96a7ee01cbabdaab0484bbd1af093f2d1da9d19864fd95cd814f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa7a57848c5bcdf0a06cfc4342f6d7133895e533e6e821218c95766e96f72ca"
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
