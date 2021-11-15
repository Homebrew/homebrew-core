class Oq < Formula
  desc "Performant, and portable jq wrapper to support formats other than JSON"
  homepage "https://blacksmoke16.github.io/oq"
  url "https://github.com/Blacksmoke16/oq/archive/v1.3.0.tar.gz"
  sha256 "5bfb23b0c527f45eacd40485779c708b1a05dd36015b50b84df29c2ac3f6cdac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "89e3b3a0e14c9d26556ba8fe0e518b2fd48f021ba4286ad1db4690c9a0d18953"
    sha256 cellar: :any,                 arm64_big_sur:  "e28f2b92624cade03207c8ebec0b8b0afa96af680b53f46cf0bed65afd82d2af"
    sha256 cellar: :any,                 monterey:       "6620d58995e30101ea8721883d91d35dbe9e475771828eb264c6cfa2a1a49ee0"
    sha256 cellar: :any,                 big_sur:        "6dac9a710d4e0d51d68488aebd186aae114c05ffc8b62726d79338b016041ac7"
    sha256 cellar: :any,                 catalina:       "2d0d73c1c9db23f83e66e2a1e2e1c2950246e108773adcce5b09c63c585cc781"
    sha256 cellar: :any,                 mojave:         "9d66884fa4c1a1b605acc19e42f4f0e4aa6b768e329f1a28b2e28337570b2288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43537a23936df709ba4fd6a25008c80a41b7914e5ef6f447965b0059e1039a14"
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
