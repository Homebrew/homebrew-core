class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.0.8.tar.xz"
  sha256 "9373740de41a82dbc98818e0a46a073faeb8a8d0689fa4fa1a74399c32bf3d50"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 x86_64_linux: "5ad82cb9b9b015843d930a873ddeba58114c99d133e075925a88a82d768bbd5b"
  end

  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    virtualenv_create(libexec, "python3.12")
    system "./configure", *std_configure_args, "--disable-silent-rules",
      "--with-python-bin=#{libexec}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
