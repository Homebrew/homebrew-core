class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "1048675edb03e3d6c72a95d9fe3334eb17b63296d0bf8c1b220bd70602877b3a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e83db47e02982c3fa24a8354fdd7b654c593953d9d4ec04b4d5376ea511e1f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f1561f1c7bfce6411cb8e0ee109cacc77d0446c9373084de77eec41300ace9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0af7005edaef4b73acb66603a3718e9ba354d9f9179ca4cad32d4acd89c2c83"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e536e222d36fef62b07922d2f8e6e343b8876133a1fed3605c8ac409267aea"
    sha256 cellar: :any_skip_relocation, ventura:       "616febbc5474c059029fce73fc3585a7919e2d364284bcd6ffda9fe3016de579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97eb07c1e015110e89ab1e26851ce13c70e417ea124f2b590af2dfd6f4bceb06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
