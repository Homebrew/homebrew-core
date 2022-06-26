class BasisUniversal < Formula
  desc "Basis Universal GPU texture codec command-line compression tool"
  homepage "https://github.com/BinomialLLC/basis_universal"
  url "https://github.com/BinomialLLC/basis_universal/archive/refs/tags/1.16.3.tar.gz"
  sha256 "b89563aa5879eed20f56b9cfa03b52848e759531fd5a1d51a8f63c846f96c2ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48a4db14f02cbd5adc8c944f79cd22c46b6d4b3f8600a3f3dc1cf091dd932afb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8985ba21dd83aafd2ab4f37687ab88f1276a6c2f1697365200d578586cf06707"
    sha256 cellar: :any_skip_relocation, monterey:       "b1715f18cf7b1567a23ae47d399995ca2b090116ee1682cd74873a2628603172"
    sha256 cellar: :any_skip_relocation, big_sur:        "591d88c0a3342d6350e6164d880040cf4e56a60e4ad78d97f4c570fffaa2b883"
    sha256 cellar: :any_skip_relocation, catalina:       "8f4c2f9c4d85a80d2e0541a2a52638b11809247bb3989e71801c26b5d70a019e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668ee321961b9840c64fbce0be72641ec4f5c12b95f18bc93a279a2db621a745"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/basisu", test_fixtures("test.png")
    assert_predicate testpath/"test.basis", :exist?
  end
end
