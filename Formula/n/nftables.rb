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
    rebuild 1
    sha256 arm64_linux:  "5e00516cc3b2c2913b7951be59528c172b0f08b1d647c1aed03077dac8c6f59a"
    sha256 x86_64_linux: "f57bf4df87b43a03ec87de442f592413521a03b39a5553bc1e493afa90778ffd"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "ncurses"
  depends_on "readline"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    system "./configure", "--disable-silent-rules",
                          "--with-python-bin=#{venv.root}/bin/python3",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
