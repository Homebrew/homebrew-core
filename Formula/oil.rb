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
    sha256 "9f58781fc2ff662be27f964a2f9c11a1dadc5a0d1ea85014de1e68f999574e43" => :big_sur
    sha256 "2a3efdd51283e63033c24b7dce9a4480016ca28f87a69cc38894c1d183431358" => :arm64_big_sur
    sha256 "4148d615a4caed1bc7fac0f596c2fe2e7c477558f353e35c78355a0dcb5277bf" => :catalina
    sha256 "eaffe4564c21f0f27144f5cabfe7e79e6807cdbb68ab63d0f1400f1446a09948" => :mojave
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
