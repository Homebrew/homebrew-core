class Cf < Formula
  desc "Filter to replace numeric timestamps with a formatted date time"
  homepage "https://ee.lbl.gov/"
  url "https://ee.lbl.gov/downloads/cf/cf-1.2.5.tar.gz"
  sha256 "ef65e9eb57c56456dfd897fec12da8617c775e986c23c0b9cbfab173b34e5509"

  livecheck do
    url "https://ee.lbl.gov/downloads/cf/"
    regex(/href=.*?cf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f64bb58b57a9e015abcc130b7189274431fae65cd13520d1b28986455146a46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef3f980b358bb74cba8de7e264897d61e16f5e2cda94ca9c4219dcbb8c9307d"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ff8fe18dbb35dff98a5e5fc00e4c92df2ae079132de0d6f719d1eec8fd7243"
    sha256 cellar: :any_skip_relocation, big_sur:        "3919568fde666b68d1504741a9c4436bcd60f171fd445e378a718534889b98af"
    sha256 cellar: :any_skip_relocation, catalina:       "14a240b51f627599ebd4cbbffc27c52d40790c6537f91f20d978d6054e62571b"
    sha256 cellar: :any_skip_relocation, mojave:         "0cbd888d1a69516d55ce6572208b6adbdcbe9df7195199ac5d6e678e3e794f85"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b94cceb52c7da6995ed4acd014350e6d9b1dbeb7d03b0c8f2256a12e7f520b01"
    sha256 cellar: :any_skip_relocation, sierra:         "5f37fd5ff05bdc66d21e9006f8907f1d19c92743bdffc2a5463251f6f681bd20"
    sha256 cellar: :any_skip_relocation, el_capitan:     "658dbcf6f4868922582db207b8713c8a9009bc99d3d976866ecfacbb9f95dfd5"
    sha256 cellar: :any_skip_relocation, yosemite:       "4b4d294a9bd632f4daa07e643f7e33e3ffcf419d4df76c6656d2c688795f0d3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8ac2bb22be4e9233091e600136fc430a95c824f7c9aae095dc662dd2c6617b5"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make", "install"
    system "make", "install-man"
  end

  test do
    assert_match "Jan 20 00:35:44", pipe_output("#{bin}/cf -u", "1074558944")
  end
end
