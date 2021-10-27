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
    sha256 cellar: :any,                 arm64_monterey: "638720c7e6b645f0d3003f6113f4261a38eeb2cb0a72aca2d9be9a70700bc510"
    sha256 cellar: :any,                 arm64_big_sur:  "78e372a317496d0c878f0b7fc8df1fbc2373e9b0ef5ae2dccf1939f4d7967fa3"
    sha256 cellar: :any,                 monterey:       "d514ea3631d1cd61a40ca72b9e42e4c42e96466a6a8e61dfe9f7cb85f49707b8"
    sha256 cellar: :any,                 big_sur:        "0a61a95aa8e9dc8b7fe527def9bf5fa0821177d1633af729eeb80eb1a97a73b1"
    sha256 cellar: :any,                 catalina:       "2cd161c4cb14133645f6c2322cfd14366ccb270a3057b46441d6beae73105818"
    sha256 cellar: :any,                 mojave:         "3918f9b4c64b7204de7b92df869dc945f11706735551750369343cb8bad16df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d7d974cb43e22f2b81342824b0f487d1c3e08af0ebfd3bc37ba77aafb870b6"
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
