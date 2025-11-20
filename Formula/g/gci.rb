class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https://github.com/daixiang0/gci"
  url "https://github.com/daixiang0/gci/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "b5863303eb0899bcbbc87995f1935d3594e3fa1eaea37d3f77de284c6a5a49e3"
  license "BSD-3-Clause"
  head "https://github.com/daixiang0/gci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f786c3e4386bf3011564ae4f7d49b5726662305f18ece97bbb061f693e6cd906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0c03634905d310823a14ef722f47b845c5cc7b6146b515d8db1d448dadb61a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c03634905d310823a14ef722f47b845c5cc7b6146b515d8db1d448dadb61a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0c03634905d310823a14ef722f47b845c5cc7b6146b515d8db1d448dadb61a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "700cf3bc54e94bd585135973e68ad53dabc9bb80b931882b1a1cab19373a6020"
    sha256 cellar: :any_skip_relocation, ventura:       "700cf3bc54e94bd585135973e68ad53dabc9bb80b931882b1a1cab19373a6020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b46392d9a7e515bf8ae3d80bd2cd888d686f4c5dfb455c3d71df4974fd1a8ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7a222a6d1853f3bce67bc65708056e6f1cf92670b5648e28f43456046405ca2"
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
