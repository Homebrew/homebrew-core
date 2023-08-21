class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.4.tar.gz"
  sha256 "9e99c9ba292c466ca39fb7f6d0053f9fe13c2768a7493d1ef88ea2ca2e0d0ca0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "75a8cc4cfa2586b342b64c65e4a6aac0d03a4fcaf9aeb3e3f5455d07282788e0"
    sha256 cellar: :any,                 arm64_monterey: "8e50955137a1196431e6323923a223bca628e6e25bc15de29a40f714e117fc9e"
    sha256 cellar: :any,                 arm64_big_sur:  "6593873b7bf1f52b6ef49efcf24a82116f67ec418180407c146cac2a7fdc3732"
    sha256 cellar: :any,                 ventura:        "74bf344804ef1017576514cabde8ca1dc51c73535cd3fca0e0c3820b0adca9f6"
    sha256 cellar: :any,                 monterey:       "fcb33b4ec3d23973937252c430bdf01c9047020d374c31e9f15f9f63e04a82c1"
    sha256 cellar: :any,                 big_sur:        "ed634cea33ba5fd7418eb32f24fd551c46bcd1b45dc1c8d3495b1136f2e7f57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01c0353f5948a11b8f17fb28ab4fa33f9b164435916b80675e15270e811d8821"
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
    assert_equal(
      "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root><foo>1</foo><bar>2</bar></root>\n",
      pipe_output("#{bin}/oq -o xml --indent 0 .", '{"foo":1, "bar":2}'),
    )
    assert_equal "{\"age\":12}\n", pipe_output("#{bin}/oq -i yaml -c .", "---\nage: 12")
  end
end
