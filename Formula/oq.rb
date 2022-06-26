class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.2.tar.gz"
  sha256 "5216b16a874e7c0e74d4e735c593c1d353061f91fac4e455f6af7975c6c22bc3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19e3bc805ea2cf7d917d938c560078e2ef3b5b6720e9b0b8869614fcbc6d32ca"
    sha256 cellar: :any,                 arm64_big_sur:  "976004ae7d622ea1c449cb3381cdd5457300e22c684ae2773bbe66271e6b1948"
    sha256 cellar: :any,                 monterey:       "85a970d2c18b511f53ff54a73bad26856e46ac5b4efdf823b4366232ba945353"
    sha256 cellar: :any,                 big_sur:        "155234140af19151527c1d013022607ae26bb9cefd252107948b6603848599b3"
    sha256 cellar: :any,                 catalina:       "101c46e52411f19a6387a48079e370f91d3b52310934a39072b71bddcf75266f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "070c9576e4e700a55cf88c2b1084b04de4033e3fbfa7c44538988bb91f897e96"
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
