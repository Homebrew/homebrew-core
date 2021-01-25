class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.7.tar.gz"
  sha256 "599a93985dd70adaf8773f021742ddced82deeb5a9414405de10f2298100ad7b"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "3c5a97efe79952d35796bd6bbe42da9c409a96cd30f0778c4b740775db3a59c1" => :big_sur
    sha256 "efa230c838f08708379180132ebc6a4ef7ceb3f621b7976ec983826df621eea8" => :arm64_big_sur
    sha256 "50a478f15af8bd3d5e04aa3ad7e76089f03b80cc2ad2d45f7dbe78797112df6c" => :catalina
    sha256 "265b248b82d7a7c410ee0545c3fa210362f7616b97e5623975fe269c03ef3985" => :mojave
  end

  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh -c 'shopt -q parse_backticks'"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil -c 'shopt -q parse_equals'"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
