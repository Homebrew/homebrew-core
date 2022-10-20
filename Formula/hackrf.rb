class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/archive/v2022.09.1.tar.gz"
  sha256 "f022878761327a7319fd1a84e59f83b0ffc1b672f2da0fe651371087f9a68ae5"
  license "GPL-2.0-or-later"
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3b9c286eba911da05c8df47bb447616925070acaa8b3d44ed2337a814ca2220"
    sha256 cellar: :any,                 arm64_big_sur:  "0131bd19e391fa3e1675115a4fa4b6fcb7db882c68ec1c9496bfc8c5ef46d096"
    sha256 cellar: :any,                 monterey:       "96418d5edf0e03c8c4670c42f7999d59541bc875462808ffc459ca7ebf5e744d"
    sha256 cellar: :any,                 big_sur:        "731540ba9b9ed12d3956e80322b2374464fa9fd7f3637620a52443d8861613af"
    sha256 cellar: :any,                 catalina:       "b4ec755e6e14ebdec20b5c6a2ecbdcca6ea675678de27ff89ce0d8c7a6251161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24573cadb29233fe862a18646f2abd83dd59e4e506d9b147163aff087cd5b9c6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    cd "host" do
      args = std_cmake_args

      if OS.linux?
        args << "-DUDEV_RULES_GROUP=plugdev"
        args << "-DUDEV_RULES_PATH=#{lib}/udev/rules.d"
      end

      system "cmake", ".", *args
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
