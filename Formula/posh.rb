class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.1/posh-debian-0.14.1.tar.bz2"
  sha256 "3c9ca430977d85ad95d439656269b878bd5bde16521b778c222708910d111c80"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{^debian/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "970ac65535d1bb793b2312b7d1ce56861576c981ffc4c1fe049d290a5ba98118" => :big_sur
    sha256 "1b66fa64e195d0429fb1f7c0d0bf7f93c147ffa8533934f694d4ac6da5c4b78f" => :arm64_big_sur
    sha256 "9a30988f801e9c31ad6fefd48a232a5c95990300eb396a4c32a991176f8350b6" => :catalina
    sha256 "20157fe0e9ff5389d07f85079a3137112cd6ad5bff5081d247e8778a082281c8" => :mojave
    sha256 "bfee90257c267d2bd68ec3501887901179f4464d3e6d5b9afb42580ef1db4677" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/posh -c 'echo homebrew'")
    assert_equal "homebrew", output.chomp
  end
end
