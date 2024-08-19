class Nftables < Formula
  include Language::Python::Virtualenv

  desc "Netfilter tables userspace tools"
  homepage "https://netfilter.org/projects/nftables/"
  url "https://www.netfilter.org/pub/nftables/nftables-1.1.0.tar.xz"
  sha256 "ef3373294886c5b607ee7be82c56a25bc04e75f802f8e8adcd55aac91eb0aa24"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.netfilter.org/projects/nftables/downloads.html"
    regex(/href=.*?nftables[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "57904ed7402df1928d981619a622ac81438b0a92ef80558ed839abb146421ebf"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "gmp"
  depends_on "jansson"
  depends_on "libedit"
  depends_on "libmnl"
  depends_on "libnftnl"
  depends_on :linux
  depends_on "ncurses"
  depends_on "readline"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python-bin=#{venv.root}/bin/python3"
    system "make", "install"
  end

  test do
    assert_match "Operation not permitted (you must be root)", shell_output("#{sbin}/nft list tables 2>&1", 1)
  end
end
