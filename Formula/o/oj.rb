class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.11.tar.gz"
  sha256 "f608a3976737415df466af9cdb0a509f26aaa6808eae8a892d4af277fbd1e395"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d4b82d54c2ad28bc055a4928bfafa55e161a8a2ba56d24f9652ccdbe5eab9f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88d80c8af2e09a21f2b6dd976138365cf3e6f44bdf8925e272fda95330d83e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d4eddaf514e3e2cc1eb096d6511c556b15444dc914359f7f83c90e17e448f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "712fc1c07494f012a1db50a300cbb1b31194a11fbf56c0703e04960ec6cb2cf4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
