class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.1.1",
      revision: "6d1404397f3c3433334418f56048bead007729ac"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7776f7200679dc7249828a8458dae80e0301a057926aed713d5770f0104750c9"
    sha256 cellar: :any, big_sur:       "a4c8d413efbb3b2cc80e796b3690dd0a74fadb47c12f513fd0c54c6258b5739c"
    sha256 cellar: :any, catalina:      "d054e0dabc7d7a420cb962e279b1a7f78faa9c6933c59a9e93569732c65ea0c6"
    sha256 cellar: :any, mojave:        "ad3d0b6ffb7c7c0069ea8d31b4f4188e676787d2db6ff0e87f4e71807448df52"
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
