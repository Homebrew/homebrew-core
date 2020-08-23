class Posh < Formula
  desc "Policy-compliant ordinary shell"
  homepage "https://salsa.debian.org/clint/posh"
  url "https://salsa.debian.org/clint/posh/-/archive/debian/0.14.1/posh-debian-0.14.1.tar.bz2"
  sha256 "3c9ca430977d85ad95d439656269b878bd5bde16521b778c222708910d111c80"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
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
