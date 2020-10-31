class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.8.0.tar.gz"
  sha256 "2f847c6a091332faa7a647291f92ff3ed571b17967c85198d34c816c40e47e04"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "224bfcd1dcc583280d917610dc35a2fcf6696e28911ce2b06fd07ae612761a37" => :catalina
    sha256 "fc06d01b383aeeba481e00aacba60ee3a2dbaf25c49cff1662a546d6a6df2135" => :mojave
    sha256 "84c698649f37d4165ed627a053ab1e89c2201d436692341559e132440e22e84c" => :high_sierra
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras=ldap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
