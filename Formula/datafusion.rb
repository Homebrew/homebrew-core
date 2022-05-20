class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/8.0.0.tar.gz"
  sha256 "243fcfae73ad86da658c396bc0cc75b44a33487c6e9eece022c2419a71df9157"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eccfe91b44c81bfd3718c115f1af48bdefd7a2b328d61b806653b40d49f27c51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e877f89b7ff5ddbe32e73c01518680ee29c73853877513a88bd44e99a0b260d"
    sha256 cellar: :any_skip_relocation, monterey:       "1ccdba5d117eba7af7b0efd2d34a98b43e959bbbe45601108482d3d76fefeaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "92f866914be955fbb5bbc6dd76797145ced8a3971b9addd7eab8d42394d475b1"
    sha256 cellar: :any_skip_relocation, catalina:       "84cf1ae2d2cbd4eca7742344fa0fc22481616462cab40c1a919196336237b2c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128ad271cf6d61ebb8f99360d08efa6a12645806e3768c0dff8dd7ada40e10dc"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
