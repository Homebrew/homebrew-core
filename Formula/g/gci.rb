class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https://github.com/daixiang0/gci"
  url "https://github.com/daixiang0/gci/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "1429a8486ea4b2b58ce7c507823c36239d88fc277c1229323858d1c9554767ce"
  license "BSD-3-Clause"
  head "https://github.com/daixiang0/gci.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca22bfa1698f88b7b13685952488a1676f72a0e1bf8f6aaa921af7f0b177cfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca22bfa1698f88b7b13685952488a1676f72a0e1bf8f6aaa921af7f0b177cfe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca22bfa1698f88b7b13685952488a1676f72a0e1bf8f6aaa921af7f0b177cfe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de2b679e09da2cdd4b851e14d02b639e3eb9f8dbd9b3b44cfbf2b8bc5b9a48f"
    sha256 cellar: :any_skip_relocation, ventura:       "1de2b679e09da2cdd4b851e14d02b639e3eb9f8dbd9b3b44cfbf2b8bc5b9a48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91bf88994d9d8986d778178b2bfeab695f73fc5923c9aee55d3283b64579c37d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gci", "completion")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main
      import (
        "golang.org/x/tools"

        "fmt"

        "github.com/daixiang0/gci"
      )
    GO
    system bin/"gci", "write", testpath/"main.go"

    assert_equal <<~GO, (testpath/"main.go").read
      package main

      import (
      \t"fmt"

      \t"github.com/daixiang0/gci"
      \t"golang.org/x/tools"
      )
    GO

    # currently the version is off, see upstream pr, https://github.com/daixiang0/gci/pull/218
    # assert_match version.to_s, shell_output("#{bin}/gci --version")
  end
end
