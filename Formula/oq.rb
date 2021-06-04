class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.2.0.tar.gz"
  sha256 "15ce979f51045370624e5e50b38ac2eb106a00d5ce9ebf9f04c7fda4a5679826"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "408b97fbe4ccc86dbeed6ae05820245caadae204441c2174bb578c22e13a5aae"
    sha256 cellar: :any, catalina: "d2534a3698eca04b9f436a4c0afab849a97d827fd189df0246d36ab4c69c5ee8"
    sha256 cellar: :any, mojave:   "527afb12eb240fd2d12e47d970802d5878801d4aa399897cfd1d611811ea8cf9"
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
