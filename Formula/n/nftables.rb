class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.5.tar.xz"
  sha256 "1daf10f322e14fd90a017538aaf2c034d7cc1eb1cc418ded47445d714ea168d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "1cdfede29ca680feb1d2adcc3a87fe2d085362050bafd708c12f840d634ea404"
    sha256 x86_64_linux: "24f8155cd129fb16a9685b95170140db1df69ff00d1327674ff41609e37bb903"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "ncurses"
  depends_on "readline"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    system "./configure", "--disable-silent-rules",
                          "--with-python-bin=#{venv.root}/bin/python3",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
