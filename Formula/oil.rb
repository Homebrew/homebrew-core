class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.14.1.tar.gz"
  sha256 "586ffd3de890ee33ae855d02ac49b06a4e85bfa1ca710e8e1333acf004d8c92c"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "83bc2d6b3cd2cab9589911098445a2983954516cdd895772d04c9d3f42331b02"
    sha256 arm64_monterey: "bc30acdfe588b8b154bf285de69efdc1f63e171937ab12b62029f53defcac4bd"
    sha256 arm64_big_sur:  "1a202d7d1b41e3173162c2c3953effbf1952fe9efb5f6cb2771d4f7bd700c5f6"
    sha256 ventura:        "b8ea0416d2b61cd3b07c5db6e90ee04613bc09599441237b63a9cc02486c8f4f"
    sha256 monterey:       "4877c6e3711c360a79547367ed169c710dc5ce27377ac52ce83c406d98f77628"
    sha256 big_sur:        "5f284386993d44c4281d2cd5fb0c23ea0d19c2cb27cc094c7f49cf743a2076ba"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
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
