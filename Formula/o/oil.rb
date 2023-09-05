class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.17.0.tar.gz"
  sha256 "f98ccad432ce05363312a9f2f34597564a6178522b20761a21554553703b6605"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "f05ba20bc4835890464a0410e2587f6acd61a41b61b6386d28b48cebfb985865"
    sha256 arm64_monterey: "f68985e017540eb66e3ea70adf216ba43ae285a87a82768698531efe413a4275"
    sha256 arm64_big_sur:  "a135b955a9e002d62e2bfb4f9e4f6c2d6871797d91e91e7d03fdf4fb4e443dfa"
    sha256 ventura:        "d021a221092656c95fcfcbbd5abc08551ff563b02a6f9273e6937d36b86ee2e7"
    sha256 monterey:       "e38408bd6bcd1864e9656a231358213d11068be8a9dc030d8978bd11861f472e"
    sha256 big_sur:        "181bb605032e097ee80b81e4dd05c57129f06501917d72f17200987a76da4e77"
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
