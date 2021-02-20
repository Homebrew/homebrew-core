class Cliclick < Formula
  desc "Tool for emulating mouse and keyboard events"
  homepage "https://www.bluem.net/jump/cliclick/"
  url "https://github.com/BlueM/cliclick/archive/4.0.1.tar.gz"
  sha256 "78f9584524b2cb4710a964f4d8e23667479f1dab37240d1ffbc8dfa9841ff1c2"
  license "BSD-3-Clause"
  head "https://github.com/BlueM/cliclick.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e97f9a134eea73034dc32929f85e4206976925ee75a8e9f07dff74c86d1b16f"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb164e96e155204666a83d0731f2115a13ecabc4ba07f8885a1194418ecd2068"
    sha256 cellar: :any_skip_relocation, catalina:      "9ffcef6839fb396f022e415925f0e5f2cd1434d0eb723694d950d84fbaa3fcda"
    sha256 cellar: :any_skip_relocation, mojave:        "bc373ee9ec978d416491fd82b3c25d02755b004b0abc1f5a73ff0b39e57b6b33"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c371cb5b700e4a5f6495545b5f83e5414fc0e0cb98be05231a7abdf6c6607ff4"
    sha256 cellar: :any_skip_relocation, sierra:        "bb47d1d8f4c81f31dc9372b5c06d3f74ecb25026805936f62e08744d1b888ecb"
    sha256 cellar: :any_skip_relocation, el_capitan:    "e8eca6037032ad2b68b9e8c4faa40adb770b10f868448e47852571f1829aa462"
  end

  def install
    system "make"
    bin.install "cliclick"
  end

  test do
    system bin/"cliclick", "p:OK"
  end
end
