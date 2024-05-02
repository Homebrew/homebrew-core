class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/37.1.0.tar.gz"
  sha256 "c0e709154eabb41bad879f52ef7ab943721ad94c63603762a7e21ddf0a2a7bb5"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1aaa0240ffe43a47fe408baf89b3f71f634cc9b332118fb1320bb868e35fa317"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57e5982f53a774733ea32b6b7390080ea4869a3407f8b6244cc980bc980bb772"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1279ab1803dfff0d6399fb7e10bb2f0afb4b871a2789b23f726edef88c701406"
    sha256 cellar: :any_skip_relocation, sonoma:         "366c4d23b10ff5c20409ba14446a9b50458307f78ae8e9dc9d5178820f11b26f"
    sha256 cellar: :any_skip_relocation, ventura:        "39cbffe22e1bb3493c23655aa5b58e636ef8176dbea4427b9cb7ce74e3693c1f"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc05db560a9371c72b96617b7fb0913cdf912ed60fae2feb6fa5727ec536c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a50689621aa3496cc117d0f46423d26bf430c8f6fc356bee593bb00bf2f9a1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
