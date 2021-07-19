class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.0.tar.gz"
  sha256 "6fe2ca27d1b1dfe922f7bece1fa88cd81357c6b95ad367420443dd06655da94a"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b51638f13d633c74dc1ede60c4a79dc62782567ac7df0ebc048fcd7b26f563f9"
    sha256 big_sur:       "ca31e5aa42c262ae4e6dc0b4118a69fb824e1944f827472464ef95f0f228eb1f"
    sha256 catalina:      "18dcb105075eb6f01855796287028304d74fc2cffb9219e9345aa6d802bfab03"
    sha256 mojave:        "4d74fd6f230cb14941285c82b0df469ff6b1bb4dc4c41627a142b31c3626c996"
    sha256 x86_64_linux:  "9307564bf4d716899d256b001373737edb8c52f269716dbfc3e2f50d6df30e59"
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
