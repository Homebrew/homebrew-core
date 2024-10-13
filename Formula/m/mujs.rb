class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.5.tar.gz"
  sha256 "78a311ae4224400774cb09ef5baa2633c26971513f8b931d3224a0eb85b13e0b"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "774c344e1bbc23f97e3d91d4fcfaa04a7f818a65b58836682005e78c5f44187a"
    sha256 cellar: :any,                 arm64_sonoma:   "730e76d17786653ff4a36ce09f749b203b6883195f645fefb9958d413a5cef66"
    sha256 cellar: :any,                 arm64_ventura:  "bdc098dc98efa7aaa8ea6ddb60d8ee9213172c287a5c3118d0f9575b862f8305"
    sha256 cellar: :any,                 arm64_monterey: "21a773ee06aae5577d93ce0ac15e87074fe99e93f1f2cbebb25d6c3c3f828c7c"
    sha256 cellar: :any,                 sonoma:         "a9dff00d5a896f441559aed7e1cfa583938e7889fd7b6cf9f0522dc2c4ab8e87"
    sha256 cellar: :any,                 ventura:        "171d8c3d6413c3a97c4d3dd39cb1babf13a92cd460f8803362a82d9ad513704e"
    sha256 cellar: :any,                 monterey:       "4d25f724d36fc11718a2937dcf44e846156f7dd1c9dd4cc4fd0cdc28248be239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5a378c307b4b3d0f14c3035959ea57f956023b93bc38011e9e8e7102b59b4ee"
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
