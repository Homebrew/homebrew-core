class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp/releases/download/v1.20.4/ppsspp-1.20.4.tar.xz"
  sha256 "4de21db3105d9d81a465a8a7e78c68ee3c0e0bf6597d1c1d530f7555f3ad8b31"
  license all_of: ["GPL-2.0-or-later", "BSD-3-Clause"]
  head "https://github.com/hrydgard/ppsspp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "822fe417a8375d4e2c0e5198051f96ca6f26f1f76860eacf3b0646d7fe3b7d31"
    sha256 cellar: :any, arm64_sequoia: "50582846511f08c2de05611b5ccb9d3c1bb150eadfa995045edf6263df1ffc87"
    sha256 cellar: :any, arm64_sonoma:  "e066b15fbd67a5e0f5bb5bd963303dc43330e0ee9664765e1c848485e8af9846"
    sha256 cellar: :any, sonoma:        "5587c7e40e5fec600c02ca548623abe932dc17ba8efa8ae8468a4558b8278234"
    sha256               arm64_linux:   "f11a8d5c8bffecf29232b54df2ef0673950535742ca3de334563e6d2c3655986"
    sha256               x86_64_linux:  "2b2a7269d65268764f50754131d9d74cd080d417e57fc4efa70d2e5f5eafc7dd"
  end

  depends_on "cmake" => :build
  depends_on "freetype" => :build
  depends_on "pkgconf" => :build

  depends_on "libzip"
  depends_on "miniupnpc"
  depends_on "sdl2-compat"
  depends_on "sdl2_ttf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "molten-vk"
  end

  on_linux do
    depends_on "fontconfig"
    depends_on "glew"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
        # Yasm is unmaintained and has multiple CVEs so will be deprecated
        # soon in Homebrew/core. The bundled FFmpeg 3 build system is not
        # able to correctly detect nasm so just disabling x86_64 asm which
        # matches Linux build script.
        ENV["extraopts"] = "--disable-yasm"

        rm_r("macosx")
        system "./mac-build.sh"
      else
        rm_r("linux")
        arch = Hardware::CPU.intel? ? "x86-64" : Hardware::CPU.arch
        system "./linux_#{arch}.sh"
      end
    end

    # Workaround for error: use of undeclared identifier `fseeko|ftello|ftruncate`
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    # Replace bundled MoltenVK dylib with symlink to Homebrew-managed dylib
    vulkan_frameworks = buildpath/"ext/vulkan/macOS/Frameworks"
    vulkan_frameworks.install_symlink formula_opt_lib("molten-vk")/"libMoltenVK.dylib"

    args = %w[
      -DUSE_SYSTEM_FREETYPE=ON
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
      ln_sf (formula_opt_lib("molten-vk")/"libMoltenVK.dylib").relative_path_from(app_frameworks), app_frameworks
    else
      system "cmake", "--install", "build"
    end

    bin.install_symlink "PPSSPPSDL" => "ppsspp"
  end

  test do
    system bin/"ppsspp", "--version"
    if OS.mac?
      app_frameworks = prefix/"PPSSPPSDL.app/Contents/Frameworks"
      assert_path_exists app_frameworks/"libMoltenVK.dylib", "Broken linkage with `molten-vk`"
    end
  end
end
