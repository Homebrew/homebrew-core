class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "20de09dae640f99e690b71da448f713ba330f78c73b9b5357d7c65ede5ce6afe"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f550b84f4f7107313347e623354f332f65e5a89173d112a2ad526b05d7c88e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7822a4b5e036a3125785f27b1bf2c4c46984bbe30be7f045e64e9a4d93e6d2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7eee5e0ce240b74a540c3104504ce3cb7f798a3e3448ae7ee59e86c6d0ba2f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a8032e3644c70a6550eca499c8fe214b275f1ef89cf96368d39c8e4e6e7547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07c89a4a0d477870b349e6466104fde4ba1e2cff74c1ca0caa095c2fde3694d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5852829a71cb69e89860753a2107257b396beb2f932dae1fe35a1de39f0b8f36"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
