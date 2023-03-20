class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.0.6.tar.xz"
  sha256 "2407430ddd82987670e48dc2fda9e280baa8307abec04ab18d609df3db005e4c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "2fbf466c4571ec7513a6e49c6381f5493ef095bc1018ea27859caf11d3873d31"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    virtualenv_create(libexec, Formula["python@3.11"].bin/"python3.11")
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--with-python-bin=#{libexec}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
