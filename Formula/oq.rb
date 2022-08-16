class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.3.tar.gz"
  sha256 "ed5d27756ea33ecbc93b967febf8cb57b35ea56c61999756cc35b414144ad23d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d13bb000503aebdf29c78c53b248e1bbc8e2efe32388befb625207330b2b098"
    sha256 cellar: :any,                 arm64_big_sur:  "bbafa275bd45dd001016ff46bddb5981582f177adee5f3f6609a339d36450fcb"
    sha256 cellar: :any,                 monterey:       "7cd9fb09249d6097ed2636f226a336f986cda0bb3547a683b737de8685ac161b"
    sha256 cellar: :any,                 big_sur:        "00fa7ef4617cdc24b2eee5ec1927cf0c51f43c6ba3456c0d7bd15887662e6e93"
    sha256 cellar: :any,                 catalina:       "e75135511b22133e7ca7c3000431b0b6b9ea491e57ca4350a3bc657d2cfd41a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cd57ce55d729c1974884bd38548b3698fa73a272760515ee6aa2f4a86df2fc2"
  end

  depends_on "crystal" => :build

  depends_on "bdw-gc"
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "pcre"

  uses_from_macos "libxml2"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/oq"
    bin.install "./bin/oq"
  end

  test do
    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
