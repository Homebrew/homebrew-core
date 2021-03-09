class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.1.0",
      revision: "80e222d91d4438f111237873c7910b4c0eacb749"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "682646cc0adae82ada228e6c5128bf7dc8cdf41754fcb71e6c35a2fdd26035a0"
    sha256 cellar: :any, big_sur:       "ec504ff4490071dfb5d06fe7dbe0739f284fefe9395c3c58a27ff1e6083bacc5"
    sha256 cellar: :any, catalina:      "92e67bf48a3d7e376b8c1d7765c286a1a6ca7ba5ad29a854ed96497485f2bb4f"
    sha256 cellar: :any, mojave:        "29454bb8040167bcf57bbca498c50212e5873d953b9ae297af7196f00cfeea05"
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
