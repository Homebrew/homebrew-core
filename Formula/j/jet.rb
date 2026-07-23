class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "3662f03800dfd897a8ba8db2549ed23857427f1815451b348bc0e6433a00f73b"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbaac193746a11fe5e445693e3bd4decb3fcb80a44e4b7da5d00b1036e6bb7d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d152a004c22cb12d0e6a906af00976f353be6487f51453afc10aa992b757d7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03a96ab9270a85758c72fe5a6d30c59d2b4bd564f78e38ba99738c9cac258e10"
    sha256 cellar: :any_skip_relocation, sonoma:        "68afae8f1b8f53a6fbffe679ebeef4b58cc93cf6a291bf05742549b68d9badc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0364f764a8c514a28fea1ff93b9c8cf7de5d608d3a185adda9879d1cb1a16fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c1221baa36f079b90ad6f56e511fbc28d6e2dae2bc14b550b68816da67107db"
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
