class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  # use tag not tarball so the version in the pkg-config file isn't blank
  url "https://github.com/ccxvii/mujs.git",
      tag:      "1.3.0",
      revision: "ebf235bfea04da1d12c77c84f9398c1c0d5aa0a8"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8717abdb989f9eaa115bbe5afac344fc517712fc825b7756c5362d9a6ec057d7"
    sha256 cellar: :any,                 arm64_monterey: "2cc98920066db183fbc6c024a676254dfb46628d3ba2e41a36cd94e35016c23a"
    sha256 cellar: :any,                 arm64_big_sur:  "49a0fa9258cb985ffc33ec3317e21ca7ce250a8e6ece38e1b65f21821410baa6"
    sha256 cellar: :any,                 ventura:        "5d06e568377be944bdf54127af5e35ebd36d9368cb38921ec867512060465d57"
    sha256 cellar: :any,                 monterey:       "70e32a32fc2f81d22e499516e97dc771c93e57c88058f59b5a7f9b7e0ce65daa"
    sha256 cellar: :any,                 big_sur:        "95c9549b0f7969d7ebec612e2d8c35bb5c2fe5a76ab353264b034abe32907eed"
    sha256 cellar: :any,                 catalina:       "4854410e56af3f104f3cb99efd5657b4a23d40fcda702c7f59701197775eb5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a414797c314cba62749d4a862dba487d6033e07fba8f04f205962a8e4e46508c"
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
