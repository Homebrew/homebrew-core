class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.23.tar.gz"
  sha256 "8050295e3a44c710e21cfa55c91c37419fcbb74d1ab4d41add330b806ab45069"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a469a1ad09212ebb4e71903b70639e4b96a2e14ae3ca1837a53b7c84152e9cc7"
    sha256 cellar: :any,                 arm64_big_sur:  "6e050244ec556752ed5cd68f7d26f4b52e4b906483f959400d17aefb055fd36e"
    sha256 cellar: :any,                 monterey:       "9e63849eb06cbef0d2b6348db53661e15923e0f0d45fe3949d8728720d9543d4"
    sha256 cellar: :any,                 big_sur:        "64fe60c280fb3f08a7bd36366e833db62096fc6954e4f9c605285a8b6475ad67"
    sha256 cellar: :any,                 catalina:       "d9820663549e09d488663a486753bb03ed0698ef6685c6a59d6eb6694f2573ef"
    sha256 cellar: :any,                 mojave:         "a37a15e413cbab56d27e3a320d7c7aad1bc955b6452724e3f8e80cd4b0b3d7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9789660ceba232ef18cbca38e40c1f72c28c2f55fcc67410151b7a478dd6f0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
