class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      tag:      "v1.17",
      revision: "493122a2fcf9ff538e242fe2844f019b53afd483"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "9aa60289422d31414be45713e58bbe932d80ef568bc428ac5fa8ecf7e81c3bc5"
    sha256 cellar: :any, arm64_ventura:  "2e87fc4605ca5277f688688b5b981fe4cf8a19ad69f21aae2f577f2f8d4adbf7"
    sha256 cellar: :any, arm64_monterey: "1e2dc1b161d90db21e372c6728feea371c8e84da25912a72e71e8216c2b2143c"
    sha256 cellar: :any, sonoma:         "0dcf6f463affe0b38ca1c6d8646d845a7ea626183026e510250df44f47e2b118"
    sha256 cellar: :any, ventura:        "1a64578255cf526f0d168f25bf20c299fd63f5f73e6bda519395501861bcf047"
    sha256 cellar: :any, monterey:       "714794e98db09fd481a00876980793b2554774ec2370a3cb8e01fabb1450aecf"
    sha256               x86_64_linux:   "14c28b32c66b2f4dfb52f53caa6cb222a2a94933085333c3fbbf3d81a5f11038"
  end

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build, since: :catalina
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

    args = %w[
      -DUSE_SYSTEM_LIBZIP=ON
      -DUSE_SYSTEM_SNAPPY=ON
      -DUSE_SYSTEM_LIBSDL2=ON
      -DUSE_SYSTEM_LIBPNG=ON
      -DUSE_SYSTEM_ZSTD=ON
      -DUSE_SYSTEM_MINIUPNPC=ON
      -DUSE_WAYLAND_WSI=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      prefix.install "build/PPSSPPSDL.app"
      bin.write_exec_script prefix/"PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"

      # Replace app bundles with symlinks to allow dependencies to be updated
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      ln_sf (Formula["molten-vk"].opt_lib/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
    else
      system "cmake", "--install", "build"
    end

    bin.install_symlink "PPSSPPSDL" => "ppsspp"
  end

  test do
    system "#{bin}/ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_predicate app_frameworks/"libMoltenVK.dylib", :exist?, "Broken linkage with `molten-vk`"
    end
  end
end
