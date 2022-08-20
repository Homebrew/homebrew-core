class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.12.4.tar.gz"
  sha256 "ac5ed4b43963ed385939fb8d9ab2ae312ab037bdd368ed52232dce2ab44b65b2"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "72af2bdfcb1f48beb2731084f9ecdc599c8d314b2defd9d2ba72cda8337e6202"
    sha256 arm64_big_sur:  "107be9c3099ba171cb6eb2cfd563bbf226622b0c1ae7b729c7f9c99cd9569ad1"
    sha256 monterey:       "fc2d55032697f456dfe29b36fc270426adbb5049982362df9abfa3ce7e27bcb5"
    sha256 big_sur:        "52fcef9a80e65cf22519024893140263fdf074195f812d98d273e37acd3c3515"
    sha256 catalina:       "11635067b3eef0573730827afbca2314691dba83426084e818547ca8712bb153"
    sha256 x86_64_linux:   "acd75d7ba11625dbcefcf40e9447c73bf0aa5e0efb2086679a72f83237149b10"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
