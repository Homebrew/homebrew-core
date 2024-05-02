class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.11.0.tar.gz"
  sha256 "bf7e42db6a219a73bace5ff977414bd79a7ce1b7085872e0c8012ee9a56b2822"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "cf32214ad659941ea1851eb3405af12e5ff997d2e9f8cb51bdc1104019b3fc37"
    sha256 arm64_ventura:  "970faecfa057afb1fc0e0cad7355f63c32a07cd5d6a212757539fdb1836b2d16"
    sha256 arm64_monterey: "77572f629ba5dcc3dd1f774e75b6481bf37289e0068d357cefe085b438a1893a"
    sha256 sonoma:         "9a6d1c18afc243a0975ef109ff95f621e2290c638e30f00d4ec96a63b98881a6"
    sha256 ventura:        "b21a06af741df2d822e5d3e2b16e0a39bc960be5e26c38e81a93a9727e077ab4"
    sha256 monterey:       "ccc35a1253b9ef4707ded64d934fd1cd7d06929126678610477e6fb4d47708cc"
    sha256 x86_64_linux:   "f88617ff915ef3ff5238a33ab17ba72425f283eaa112d09b0f5143b9544bdbe1"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
