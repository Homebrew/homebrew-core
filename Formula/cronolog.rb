class Cronolog < Formula
  desc "Web log rotation"
  homepage "https://web.archive.org/web/20140209202032/cronolog.org/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/cronolog/cronolog-1.6.2.tar.gz"
  mirror "https://fossies.org/linux/www/old/cronolog-1.6.2.tar.gz"
  sha256 "65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a4e3d4430cc1394a04c53a63725012906738f26acc227d58f91dd84ce3e6335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "105b3e20c9a2c742c71e3c0367c451b37acc11945f05597e72a4c6ce98b9e82c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcb59364b5df275862b07d39e801c3564047d59c624d44145010cc446b8002bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20a3d3f835199043f5420a386baefbf2b3ce1afbe78499e313c5e2de1684f52"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a14dc1d1d5b30969523a75ef785e81a46f1961851adae8cc63c828b89b03a9"
    sha256 cellar: :any_skip_relocation, mojave:         "c99140b690aae4c8e28b53ba787ed5aef53d3fbc867186aca47cab021068db40"
    sha256 cellar: :any_skip_relocation, high_sierra:    "47a40bdccb74cb45e3df9e73306162ecc7206c26760521c6a9d8760872769b6b"
    sha256 cellar: :any_skip_relocation, sierra:         "66ad5bfa0080775875d2b72cc2bbd66bc8ee8de7ca1d482217414ba5b805f977"
    sha256 cellar: :any_skip_relocation, el_capitan:     "964df15660a5c0ec25bedec56aeb128ae93794a8ad721c1c600e377df9be1c2d"
    sha256 cellar: :any_skip_relocation, yosemite:       "f3f485105f7466422a507bafef3acfd741f18b8ab26438c267d10dbf4701282e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7e0546314cd92d44b009de1894f4739f75865da5f95d425e305cf6ffeac10d"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end
end
