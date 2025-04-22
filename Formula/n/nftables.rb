class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.3.tar.xz"
  sha256 "9c8a64b59c90b0825e540a9b8fcb9d2d942c636f81ba50199f068fde44f34ed8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "19a175d38550ac4c326c1e4188e8df5fb005e9e6081e277f81039195297fdcaf"
    sha256 x86_64_linux: "bb22f5e217d3160d41da139b1088f37b28efc2d83df39ea1bb2635701cf5f745"
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
