class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "43cc77a94f65b2ba940310ac4268567d61b9cc01414b0c70cce45c5a60c8e4ec"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/gofumpt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4551615ecf46efb1b4d0c0cf63ca7be7dc3aab0ac7fbd239a9e026b8db02bb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4551615ecf46efb1b4d0c0cf63ca7be7dc3aab0ac7fbd239a9e026b8db02bb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4551615ecf46efb1b4d0c0cf63ca7be7dc3aab0ac7fbd239a9e026b8db02bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4551615ecf46efb1b4d0c0cf63ca7be7dc3aab0ac7fbd239a9e026b8db02bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "834a798fe891e01a6aa6f7001921807428f7b08f00074093b61d9db2f62a8a0e"
    sha256 cellar: :any_skip_relocation, ventura:       "834a798fe891e01a6aa6f7001921807428f7b08f00074093b61d9db2f62a8a0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f234ab78d80bccc966e642f5cdcb20383490c8ff70ec360719e56af106fdd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b7d8a96c584746e862c805a12270d139d9c204b358f2a0ad3648d391ff86612"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"test.go").write <<~GO
      package foo

      func foo() {
        println("bar")

      }
    GO

    (testpath/"expected.go").write <<~GO
      package foo

      func foo() {
      	println("bar")
      }
    GO

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
