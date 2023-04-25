class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.3.tar.gz"
  sha256 "e2c5ee5416dfda2230c7a0cb7895df9a9b2d5b2065bb18e7e64dec2a796abe1b"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "adbe9447f9f9f2cd0a9bea7792e21216eaa494092f17dae1f911ffbb80125158"
    sha256 cellar: :any,                 arm64_monterey: "73536860e13e1a1fa956e5c7dcb55e573ff7953be8792c0b77302573650a0ce7"
    sha256 cellar: :any,                 arm64_big_sur:  "cf8314788424777f86f9fa7dfb287868d5bc27dee2c6b5871aabb351794f3349"
    sha256 cellar: :any,                 ventura:        "fef93dae516dae1b78638e8cca4cc4b51c233f58c1f245dd4908a7e60df3fdc1"
    sha256 cellar: :any,                 monterey:       "29bc1c4bc8f5bf921cf31001125da52cd8d4a04e821743b9a5fd464a90ed711d"
    sha256 cellar: :any,                 big_sur:        "59a246f51508566f1beabe0eee40e7b29f432319ef665ab516abc674eacfe6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab5d68da455da1feeabd6550b7b529ad027d043e97ef9b32e13b505df0c92019"
  end

  depends_on "pkg-config" => :test

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "prefix=#{prefix}", "release"
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
    # test pkg-config setup correctly
    assert_match "-I#{include}", shell_output("pkg-config --cflags mujs")
    assert_match "-L#{lib}", shell_output("pkg-config --libs mujs")
    system "pkg-config", "--atleast-version=#{version}", "mujs"
  end
end
