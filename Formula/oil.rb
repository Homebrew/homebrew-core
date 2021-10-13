class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.3.tar.gz"
  sha256 "fd96dd339b3b29096e56c930bafd49ccaaae4cf2fd7997f556e7efc78b8845cb"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "88b0b7a6c385518c053cbfdf80fec81265750d25ac9e742b6eac6aaa9d678246"
    sha256 big_sur:       "20b9de690d6833038f165ecb870df80862e2ee51bce3aee51938b69fb66fa05d"
    sha256 catalina:      "e4bd8dbcf5a9f183be2bc77f93eed84e8cfaae5b54864122890f1e6d5b26090d"
    sha256 mojave:        "89ad6d3b4af7cb8ef5517c69c7e6aa2c11c9e01ae2cf7cf25027ec0b7918dc3e"
    sha256 x86_64_linux:  "7f36287404cee830b84e97f346e7e764bb9a036e203e9387edac04b8855d365a"
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

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
