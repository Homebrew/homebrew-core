class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/greatscottgadgets/hackrf"
  url "https://github.com/greatscottgadgets/hackrf/releases/download/v2022.09.1/hackrf-2022.09.1.tar.xz"
  sha256 "bacd4e7937467ffa14654624444c8b5c716ab470d8c1ee8d220d2094ae2adb3e"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/greatscottgadgets/hackrf.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c6c13e649df4b2457a93a5269f2376cfc7fab7cafc88afd4914cdce52d238e1"
    sha256 cellar: :any,                 arm64_monterey: "8c6eed0a7f15d8fe524f3db7256624caababc440e6a3db0d2c7ce39244592d87"
    sha256 cellar: :any,                 arm64_big_sur:  "5ce7b90e03e6cfe0e3a4cae61133539d7a930a5cbfb3d841918a4adde7bc95d3"
    sha256 cellar: :any,                 ventura:        "fae966e776918d07134f6cb9db2ff637e5693a32fa5bb29116828f0a219174b1"
    sha256 cellar: :any,                 monterey:       "afbe5e6273018258bb621487af4d00e6dc5167ad8d153eedddc85679b530f227"
    sha256 cellar: :any,                 big_sur:        "5d33b942ba20327b818a4f3bb77a62bddcc15956708ba1cfee27daabb748c14c"
    sha256 cellar: :any,                 catalina:       "e4e88439a674526e27764c61813571ded730ea4e7ab8fbf1e573332e428d4ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2009cd97f0d99ffe8a075e65fd329c0687997336bf260374a1cf08cba4aedbb0"
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
    pkgshare.install "firmware-bin/"
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
