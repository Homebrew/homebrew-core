class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.2.0",
      revision: "dd0a0972b4428771e6a3887da2210c7c9dd40f9c"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a94e31250222ad2105bb9ada248540edf2709980dc7f160909416f067744647"
    sha256 cellar: :any,                 arm64_big_sur:  "e7bb9ec701b195dc73bdcea8c888745811b3e1c5ea0db69fd6f5c13d4500b11e"
    sha256 cellar: :any,                 monterey:       "e77cc955e112e39425ace8bc18456cb5271db4d1f8d1aa730fd8e60a5b1cbfd6"
    sha256 cellar: :any,                 big_sur:        "0631602182949a2efaa1848b960d182099b426b22f4697744ef2a4708780af91"
    sha256 cellar: :any,                 catalina:       "0548c920d09d53c3c3da0ecf98cc24e5b47491e41e4d9ccf1c00ebbd6a19083c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8df7e22cd7528ce683daf23345ea3b0b1d32debcb190fad3236ef7ee0533a78"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared"
  end

  test do
    (testpath/"test.js").write <<~EOS
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    EOS
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
  end
end
