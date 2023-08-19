class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.16.0.tar.gz"
  sha256 "4cfb601d5dbcaf01d25b3168a1e3647b8537c5b9866561225d8d38f9b61450c1"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "aea61f9ee641f1d66799bbe852ec6f097420d8cea4bd1e01d5786c5eccd35d82"
    sha256 arm64_monterey: "397340b987b311958f74dbe7b1eecc667410d0aadfde02fd27dc6d1aac8044a3"
    sha256 arm64_big_sur:  "f10be0289cd653a868da70cb6309bee7a2fc7ee7914e9c220947fb8827cc95b6"
    sha256 ventura:        "aee06ce4c41871c88f7c427cf7ce22a8931515356909c8c3a94c95ac2ebeefde"
    sha256 monterey:       "e46cc3de905dc3f282432908d957d6c60c71e0900044bdc1233f7d4557ac0ad2"
    sha256 big_sur:        "2fad20c3fce33d5343449dc5c23863664b8ce024bfc01b5f06b2e87e0f0d9d72"
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
