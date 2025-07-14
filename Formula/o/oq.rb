class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "66b2d879b6e2061121c50b8e584ce82f95fe79348bf3696ca38e5910a6c42495"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a3da7d5c1facf9978ed2e5e4b837db7979b6123839d133c947b9eb9b1200762"
    sha256 cellar: :any,                 arm64_sonoma:  "9ac4ab6b25021efebdd52241b9018349fe42721bf3545bdb991e79fa55bea62f"
    sha256 cellar: :any,                 arm64_ventura: "db3b7b294448ad7861fdbd8c5e7356e56f60567412c8b7a423b2278618975645"
    sha256 cellar: :any,                 sonoma:        "64e1f4aa81d4189fb7d5cb01f9a1675779243b9906c07cd0a1fce59b7795d702"
    sha256 cellar: :any,                 ventura:       "40e53859430f914af54832221b6c6851ddd6f596cddc047d0d59404f91bb483a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee6a792a88c20a7d9aef0fd7ef3ae14ed64d1ba33f2490a4cd9d42f9b860c77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b1fab86fb911af9ac17c870211e41e94fa4d3ee655cf013153807b6c9ab0f7e"
  end

  depends_on "crystal" => :build

  depends_on "bdw-gc"
  depends_on "jq"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "pcre2"

  uses_from_macos "libxml2"

  def install
    system "shards", "build", "--production", "--release", "--no-debug"
    system "strip", "./bin/oq"
    bin.install "./bin/oq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oq --version")

    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
