class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.1.3",
      revision: "c3715ce3db4cc37ea46af8dbc891ecee1ca1b2ff"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4a9c425ba618532c01217ca4b40bc98e6ed3db93694a738da552ddcb5a368e15"
    sha256 cellar: :any, big_sur:       "232f818ac53dda527860225fa358b2e7aa46f1c1385335406a48c9254dbbcce7"
    sha256 cellar: :any, catalina:      "7a17de9728ae20735d5ed74719a81aaa5be74c37d726f11dc161a7c5ef8ba8cd"
    sha256 cellar: :any, mojave:        "d42e999efee733893ea29b4ab71582cd26954d25ee6d258a2eb944d6c69a96dd"
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
