class Gistit < Formula
  desc "Command-line utility for creating Gists"
  homepage "https://github.com/jrbasso/gistit"
  url "https://github.com/jrbasso/gistit/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "9d87cfdd6773ebbd3f6217b11d9ebcee862ee4db8be7e18a38ebb09634f76a78"
  license "MIT"
  head "https://github.com/jrbasso/gistit.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1a06e1bb0431938ebb2e048e56231e602d807d668f0dda8086a247d0e12f06cd"
    sha256 cellar: :any,                 arm64_sequoia:  "512dd9f0ab0f762ef21cadb25d38e40bac914c1d7fdbc9210eb086427b555dd8"
    sha256 cellar: :any,                 arm64_sonoma:   "aa07e24a4a15c38c3859fad46d9e9d481b82779c3935ee0417167995b85d7938"
    sha256 cellar: :any,                 arm64_ventura:  "49d1941ce30616b39307aa87bb628785e9dbd1017f8b4c312f7d24ff2ebdc40b"
    sha256 cellar: :any,                 arm64_monterey: "a56fc428aa4bb3b6c0f81c25542fe92b5c78ddc7f10159b1e626dad75356c4f7"
    sha256 cellar: :any,                 arm64_big_sur:  "ad2652284c1907697535715d31eec9dfb558fe123b8cfe6aabf76ef0bd858cc7"
    sha256 cellar: :any,                 sonoma:         "8f6e92ac090b65cefd13f70bf9177e32de609585ed58a1266ac70141a0af1d97"
    sha256 cellar: :any,                 ventura:        "d1c3d1b689d9f2493532bcde527ce8a8627a40e5a9b40235a6d4934706864ba7"
    sha256 cellar: :any,                 monterey:       "f4f4aa3d57eb29d34654abc12b9919879e34ecb532b0b77e139216dbc9b6b30e"
    sha256 cellar: :any,                 big_sur:        "090920bf2761a37d9b9877386a1c0b4466ba80a8c412e807a7a03de14239a3a0"
    sha256 cellar: :any,                 catalina:       "844955e49de622786a9a676e91b767926ff9953c950db2affa98f6d82978899f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "051a78fe9ae05b66074da6eb825835c44fd0cd66db0a943111d20cb1e076e54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4bf0e5e2cfdb3adf8c3e9170c7239c8d5fe95339c36b13b607adfc926978e61"
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
