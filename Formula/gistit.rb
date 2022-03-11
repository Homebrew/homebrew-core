class Gistit < Formula
  desc "Command-line utility for creating Gists"
  homepage "https://gistit.herokuapp.com/"
  url "https://github.com/jrbasso/gistit/archive/v0.1.4.tar.gz"
  sha256 "9d87cfdd6773ebbd3f6217b11d9ebcee862ee4db8be7e18a38ebb09634f76a78"
  license "MIT"
  head "https://github.com/jrbasso/gistit.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a56fc428aa4bb3b6c0f81c25542fe92b5c78ddc7f10159b1e626dad75356c4f7"
    sha256 cellar: :any, arm64_big_sur:  "ad2652284c1907697535715d31eec9dfb558fe123b8cfe6aabf76ef0bd858cc7"
    sha256 cellar: :any, monterey:       "f4f4aa3d57eb29d34654abc12b9919879e34ecb532b0b77e139216dbc9b6b30e"
    sha256 cellar: :any, big_sur:        "090920bf2761a37d9b9877386a1c0b4466ba80a8c412e807a7a03de14239a3a0"
    sha256 cellar: :any, catalina:       "844955e49de622786a9a676e91b767926ff9953c950db2affa98f6d82978899f"
    sha256 cellar: :any, mojave:         "c55986f583c7d8744c4009f7856d00568ee5c3a31836075dd8b44af7b9807284"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jansson"

  uses_from_macos "curl"

  def install
    mv "configure.in", "configure.ac" # silence warning
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write "Hello"

    # Gist creation should fail due to lack of authentication token
    assert_match "- code 401", shell_output("#{bin}/gistit -priv test.txt", 1)
  end
end
