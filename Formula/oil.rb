class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.7.tar.gz"
  sha256 "5c0574bd8926914edf5d8b0c29e7a39f83ce8be81c11c35c8ff5213d79a03426"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7ad6534356685897b6901e9603cf1f81ab5ebcf5e37be53155d5cc1cdd46d312"
    sha256 arm64_big_sur:  "c0537e616e5acea118fad6b7bc3b857797290d6905e1a8303fb49b7df0c3fd7f"
    sha256 monterey:       "42f82fb70f2741f76adc9907d14b5ee30bac2089cd5c6c7d9af7dddb6fa8ad47"
    sha256 big_sur:        "5e74ae84411315e5dd3311dc2d71737e1c30977ab37a178a0d02183b8436d2f5"
    sha256 catalina:       "bffcb548ffcc06f42da0f6f16c8a17065c429ffa28b02d7cf62cdb954279adb8"
    sha256 x86_64_linux:   "ff0240a487ac4d200280fedb41fcd2dcb8aa7335b6a29c0f9b83bafe5f22c68e"
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
