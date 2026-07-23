class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.6.tar.xz"
  sha256 "372931bda8556b310636a2f9020adc710f9bab66f47efe0ce90bff800ac2530c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "58f4138191485285a528a4c2e5648dbe07fab4d2769d545f7c2b0fe96e1ff6e4"
    sha256 x86_64_linux: "02da0add39259afda8f58278a408984fee95b27b711f281e8cfbd6dcbffeec27"
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
