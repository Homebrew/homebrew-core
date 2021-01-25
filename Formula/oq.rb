class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.1.2.tar.gz"
  sha256 "1bd940a72af556a4e685086ca0d3a363d71e3cfedeffb36f865f38d44386f94a"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8f7b2ca6c5024482c86818f0ce340c055f6e57929bd56f53a2b2449f92f5adf1" => :big_sur
    sha256 "13b8ad8c3bea0891d91f8d0a97c42f8ed921d38b0d08431e82971607d03e01ac" => :catalina
    sha256 "82c345a8dc7d05c137dc7b9a81509ef86c6e94a3072e3cdf37c281a6c48fe5ad" => :mojave
  end

  depends_on "crystal" => :build
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
