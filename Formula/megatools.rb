class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.10.3.tar.gz"
  sha256 "8dc1ca348633fd49de7eb832b323e8dc295f1c55aefb484d30e6475218558bdb"
  license "GPL-2.0"

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "029b622c6ac6df9447982800db0527a81b8fd83f61be8c51572cbcbdc2559f37"
    sha256 cellar: :any,                 arm64_big_sur:  "9aa259fd94e583acf13b382bbf3f300632862741b34f78d8f853b976306bc224"
    sha256 cellar: :any,                 monterey:       "88e01f0fb8a929bad460f1f887a14b66406f4245f63b1a30a75002318d0a14e6"
    sha256 cellar: :any,                 big_sur:        "cf95741a2c3766205c7e24a56018b07ba5716a6c2ae889ecd35d3bd9990a5f02"
    sha256 cellar: :any,                 catalina:       "88c7b8cf60517507c7d6e7d9709b53bca671d949c7363c117e27ffb7d860f855"
    sha256 cellar: :any,                 mojave:         "21844a1f366aec458b92ad00debef361388aca790bdd43583ebe51df22e7f68d"
    sha256 cellar: :any,                 high_sierra:    "0f295ea8f68a858f114ef09bd4f53b82c5a401664e16beee28af7cca2d1aef5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f981aea4ce43496323a83ecd3e1c9c6de26ed9b68300700774aeb7f50ad535"
  end

  depends_on "asciidoc" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
