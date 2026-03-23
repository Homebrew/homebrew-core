class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.60.0.tar.gz"
  sha256 "001dd608ebe0d8b651069983690cc93fe7f3e41ac11a50fc591b22c2fe97d9a4"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "5f885694a233ea1e3db8bdc5a799f00400f565e5cbdc3ed7c180aa29cd395c45"
    sha256               arm64_sequoia: "a9106acb94542c571815b586d25ed78a4223a3eb854c586a8a70f15fe1bd222a"
    sha256               arm64_sonoma:  "798d40615dd2a64df3125a4d1c9aca32918f7831c2b62d4c576d0c486d827087"
    sha256 cellar: :any, sonoma:        "208171293215e7a1549dd4e1be8c6c92e068002a9edd0100b09bbac1677ef4d1"
    sha256               arm64_linux:   "be63303a19ab3617c7d5cfb095a0ce76d70993b78bb4ef1cf1afc39da9ca13f1"
    sha256               x86_64_linux:  "fd31a88c569c2d492c822571b9a6e518edf2933cd0055ceb87f39902ece16580"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
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
