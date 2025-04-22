class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.6.1.tar.gz"
  sha256 "571ff73fbf0ae3097f0604eca2e00b1d8bb2e91affe1a3494785ff21d6199c5c"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bd8606bc58d44abfff04e9574cf0264e5c5ee9f75f64374aadae9096004b55b4"
    sha256 cellar: :any,                 arm64_sonoma:  "4d47ecab5d75443490dcd062d0b185dcb2fa3c7ac2bc30f4fbcdfdc61736ea6d"
    sha256 cellar: :any,                 arm64_ventura: "e0785f59cb7309e691469fdeb7ce2a976b8bc49a112125957331ae47c2b95225"
    sha256 cellar: :any,                 sonoma:        "5e8db7aab33dd0786c52743172f8c0a7a115633d8585da1081c4db87849d0c5d"
    sha256 cellar: :any,                 ventura:       "201f73994bf3599b53d7512dfad1dac1ab40e998ca4d2ed50bcdc9df6a66d725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67fbf006d3a4971f0ba3e42be0eed2ea3454b82df07a7b9c7ae1f450574a6cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ddc87ece74b77897ffacfefd6c66defc4196c7d7e4a55dbe702479224bc693d"
  end

  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.chrony.eu iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
