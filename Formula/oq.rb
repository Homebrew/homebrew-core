class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.2.tar.gz"
  sha256 "5216b16a874e7c0e74d4e735c593c1d353061f91fac4e455f6af7975c6c22bc3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2aa2e6eeb0a32d97326ba67d7e34f5a14c5e961be521ab50f51743844a41e31"
    sha256 cellar: :any,                 arm64_big_sur:  "4f2af5393a47a2bfb894c1632babc3caba61e8b9c567643abd58d8f048f3927a"
    sha256 cellar: :any,                 monterey:       "dc0e9507afa4c44bd1de1fdc9c324a2c1b69cda80cbaeb79d06ada8f31cb808d"
    sha256 cellar: :any,                 big_sur:        "fd56db70a681092920947b5bef4a081626d0e415c1292f477c81e8b722497084"
    sha256 cellar: :any,                 catalina:       "82243f591855cfccad6379fccd5c61738ede5cda01a9fd6bdc891693dc50f788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2431f3e1bbd66dfa2651be2bbae21e197d87fbe0d524ede8236606c5c76a9da5"
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
