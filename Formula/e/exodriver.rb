class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "https://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "ef11760322b31f16802ec202406e780339f54bde774689b97e926778417d6c79"
  license "MIT"
  head "https://github.com/labjack/exodriver.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f23e8cc706eadf6f9d2c92ba45bda0a06c3606a0c613342d6159a9b9a3cd26ca"
    sha256 cellar: :any,                 arm64_sequoia:  "be1e521d58daacc6bcb480985b374bc9e17075ed0a843fca9145f0d9c5f56aa0"
    sha256 cellar: :any,                 arm64_sonoma:   "459ce6ca331aeac97187dda22c289353e521a130ca33f3db6db8810b64d9ad6c"
    sha256 cellar: :any,                 arm64_ventura:  "70b1afd209046f565518384c2c974346ca96324beb2dc51fced383463c6133bf"
    sha256 cellar: :any,                 arm64_monterey: "dfa84090b35d7105eb7e57d95a8aa1c29d82996b530ab185996d3ac9ab09e01a"
    sha256 cellar: :any,                 arm64_big_sur:  "cf6b1fc2151d7058b04b0e21ef74604a657ea8fc02f61de05bb05ff3fc4c0e9f"
    sha256 cellar: :any,                 sonoma:         "bc4979f9cb06b3bf093a6f7a5d60c2b372299c0c0dab38e24cb0833767f6b4bd"
    sha256 cellar: :any,                 ventura:        "32715a1a59209051175d941d67522ac295d1676a86588029a88b1450a15e2688"
    sha256 cellar: :any,                 monterey:       "22a821cbd31ec096872832ed6d0cb11aa0c5790f2db69d4bc2782cf3b619c454"
    sha256 cellar: :any,                 big_sur:        "507baa6e157dfa2b3b5f824aa6a73fd58f19daac9b1e73fd735048323fb241cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6e93c4b3daba5af22be68619dbdc877fe90d092abc29b5789d1afd2394e163bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69e819a81bb5dea9e4281eb7edd24d70409c8db75c2d6eeba1a9f90c24ebf3b"
  end

  depends_on "libusb"

  def install
    system "make", "-C", "liblabjackusb", "install",
           "PREFIX=#{prefix}", "RUN_LDCONFIG=0", "LINK_SO=1"
    ENV.prepend "CPPFLAGS", "-I#{include}"
    ENV.prepend "LDFLAGS", "-L#{lib}"
    system "make", "-C", "examples/Modbus"
    pkgshare.install "examples/Modbus/testModbusFunctions"
  end

  test do
    output = shell_output("#{pkgshare}/testModbusFunctions")
    assert_match(/Result:\s+writeBuffer:/, output)
  end
end
