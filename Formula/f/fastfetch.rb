class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.64.2.tar.gz"
  sha256 "28db81d6568f28281d9aab9e88d5a4c7892d519c54b8739eef17953cce6802d0"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "2efd2ba5f2b5c939bcbbc757161c841de3735067b60f0027447329a4546ea1b0"
    sha256               arm64_sequoia: "aa1cf991d864c264534888fd78574c3d9c2fc6ff3a07c6d28249f819a9b3d47f"
    sha256               arm64_sonoma:  "0dab8f7ae987468bcb638e850c9ec9780559b56a8076b718da7c92c758cf52ad"
    sha256 cellar: :any, sonoma:        "580290bd45bca5f0d472bdc74ede2bfccfbe098af69563a3dc2cfad7dc12e216"
    sha256               arm64_linux:   "f90a11a0de9db052a2c87ecf751b9e557afa1fc11349e1bb46a8377505ac0eb2"
    sha256               x86_64_linux:  "fab53ef1771ddef1c5d52224ecf4e92cb3279bf6c7ba73f224efc9e31dee008c"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "lua"
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
