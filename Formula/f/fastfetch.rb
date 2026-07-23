class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.66.0.tar.gz"
  sha256 "547883c2f0dbc85a4545d4533f5b812fbc4c8ffe1271056de18b51994acbf474"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "a38e8a11125f7101e7d5a977c2cc2cd6c29c979e4c66d9d66233d6e96b50e175"
    sha256               arm64_sequoia: "002e451e0b7ec7c6ea821cfe65b481e5f19b96e409738de04a21b425d2a4e0dc"
    sha256               arm64_sonoma:  "6780f939cd4794f22ae9c4383218caae6cb8b30de4f04df239f2eacc0a00e871"
    sha256 cellar: :any, sonoma:        "e87347425857e28c6420d697675554035d80d2730924e0c0f0c0040c8626b7c1"
    sha256               arm64_linux:   "d900be92fb85199f4ecdbf7005bf23ee29af96b1e91370f1e9ea3aabd5d6368c"
    sha256               x86_64_linux:  "9025da9b14503a7e55d4b28c20d10978a85cd47f508dd93bbf8a35a03579f22c"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "lua" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
    depends_on "zlib-ng-compat" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
