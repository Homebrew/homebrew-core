class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.3.3",
      revision: "57e3f01d5f29c5823be725d96284488edf5f8ae1"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67b0f0b5da7f7068bc5ceaae7cb2057d7523aadecf4b92da8eb967ae7bd049d1"
    sha256 cellar: :any,                 arm64_monterey: "2c27809e1c3b82eac6cad849b735d9da958ca6b235fa8f6bb777a74759d106a0"
    sha256 cellar: :any,                 arm64_big_sur:  "d5877bcfd36acbd4a40ae2e225fb13a5af73c78147c2f8b260a8f3b4432f9427"
    sha256 cellar: :any,                 ventura:        "35b4f3d06f7e7efa10ebb992e5c88c343f225eb86a4b7abf5b848ef707d81f36"
    sha256 cellar: :any,                 monterey:       "008c3cef8cf1aca12fbfe055a82be756e3bf79b7bdaebb9b999b2d92c83f1979"
    sha256 cellar: :any,                 big_sur:        "e9f7444b3d9590a01d1e214c4b2e7df388b4c7cbfe52cbbaff42b0b693a834b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3accf35f6e3756676992e88f1e4e5600829cf99f59dd149379a3baf6e6b140f1"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
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
