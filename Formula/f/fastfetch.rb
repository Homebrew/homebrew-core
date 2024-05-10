class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.11.5.tar.gz"
  sha256 "83b7699d0aee3aa1683721fe4b82d667c88e97e257d48e9efe586b0e830f8a64"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "de0df2b9e129d1946f55852e2b34aaa621b817df284cbf0878014510a73d87fb"
    sha256 arm64_ventura:  "afd49e9dad0e30bcc3dcf2c2880aead6de9cb430b8041d50ac51b5f8aebd7440"
    sha256 arm64_monterey: "8194a5e274c2343adaad25136ac36ca3f4b0411d3a89783686d3a8250cd02494"
    sha256 sonoma:         "5fcd654c044a5667f942446822f000dd1f197aabd236e7853050277eb4c8a2a2"
    sha256 ventura:        "5b4295872f7c9f9f4b2e0f70ee57c170925dcf2c230419afcb46ac9365150576"
    sha256 monterey:       "241f6f1bb138f9621871c7078406af74d44641b0e69d1651a9853eccdde03c72"
    sha256 x86_64_linux:   "f5a247ed4bcafc26a741d43a4003b19dcea510c789172f0974a4e23d63feee15"
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
