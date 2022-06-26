class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.0.4.tar.bz2"
  sha256 "927fb1fea1f685a328c10cf791eb655d7e1ed49d310eea5cb3101dfd8d6cba35"
  license "GPL-2.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    virtualenv_create(libexec, Formula["python@3.10"].bin/"python3")
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--with-python-bin=#{libexec}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
