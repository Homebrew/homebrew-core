class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://github.com/antonmedv/fx/archive/refs/tags/33.0.0.tar.gz"
  sha256 "b619c18a3cbc7566be1c7fecfc802d469402cf8eae6a70911359c4de7eab07ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59b6e71e63c16a5461d2b3cf5de6946e2b3b17873dde6b85d23213cfd338fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b59b6e71e63c16a5461d2b3cf5de6946e2b3b17873dde6b85d23213cfd338fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b59b6e71e63c16a5461d2b3cf5de6946e2b3b17873dde6b85d23213cfd338fbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3331762edd4b0820b2491fb06e367d822cdd880bba3f66a716b394738cf3a6f0"
    sha256 cellar: :any_skip_relocation, ventura:        "3331762edd4b0820b2491fb06e367d822cdd880bba3f66a716b394738cf3a6f0"
    sha256 cellar: :any_skip_relocation, monterey:       "3331762edd4b0820b2491fb06e367d822cdd880bba3f66a716b394738cf3a6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48e27b14c88fe47e17b0092343b4d9d4bef7d9472dc0de12a4d7bdc03c48135"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
