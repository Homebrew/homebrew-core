class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.1.tar.xz"
  sha256 "6358830f3a64f31e39b0ad421d7dadcd240b72343ded48d8ef13b8faf204865a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "49760ce306d0ed33f13a26b25b00ee965fc8f4f64f902c8ef8ef4a639a210527"
  end

  depends_on "pkg-config" => :build
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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python-bin=#{venv.root}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
