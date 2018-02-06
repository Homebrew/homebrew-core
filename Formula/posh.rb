class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/repository/debian/0.13.1/archive.tar.gz"
  sha256 "c2c10db047294309a109f09e0c76a0cdc33af39563c847b84149b9ac5210f115"

  head "https://salsa.debian.org/clint/posh.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/posh -c 'echo homebrew'").chomp
  end
end
