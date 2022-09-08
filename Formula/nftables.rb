class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.0.5.tar.bz2"
  sha256 "8d1b4b18393af43698d10baa25d2b9b6397969beecac7816c35dd0714e4de50a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 x86_64_linux: "1fd3fc86a65b99479d91f7c27dc13207feecae2810d7cee3ba607ab6a091dcb2"
  end

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
    virtualenv_create(libexec, Formula["python@3.10"].bin/"python3.10")
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--with-python-bin=#{libexec}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
