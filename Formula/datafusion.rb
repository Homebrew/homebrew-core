class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/16.1.0.tar.gz"
  sha256 "a9636f289fdbf72b65d73e13448645b4288b104b9c924d8b62b4d31374c861fc"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b62ca884947d160a61214a0cf3dd37602bfa0ae99fa10e2c0abe637725e2f142"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae1ff3bf8ff90537975af878b1afe4fc11d02e2eddc78ef13b81cb4c3e871678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5c00d8e72bfa59e4985565f5e639c6a0e3cfbffe9fdbf03a1e0de5d9850d8be"
    sha256 cellar: :any_skip_relocation, ventura:        "feff195131a1cf4b4d22763c40d27f510a13f3e4a3a0ab9561cfbe45d0f2254b"
    sha256 cellar: :any_skip_relocation, monterey:       "1e66ac4d1d2a9e67a02af87d4b1fdeea3d5c47a9a202753105f24eabca6484d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6664a6e8f6b2a9feb8fccca9f312851cc0e5569a712ce27f26f9fb48498b1d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f536b810076e4e428c2b149eb24a1bfcf58c2470879726498b04b4d39233156"
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
