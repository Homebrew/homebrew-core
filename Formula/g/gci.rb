class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https://github.com/daixiang0/gci"
  url "https://github.com/daixiang0/gci/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "b5863303eb0899bcbbc87995f1935d3594e3fa1eaea37d3f77de284c6a5a49e3"
  license "BSD-3-Clause"
  head "https://github.com/daixiang0/gci.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0707566034467c1c8d58e01a47add8cc7c608595e5427f03e7a0c8f9396a8f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0707566034467c1c8d58e01a47add8cc7c608595e5427f03e7a0c8f9396a8f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0707566034467c1c8d58e01a47add8cc7c608595e5427f03e7a0c8f9396a8f6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "165b2c0724ca01b1c99216278ed57cd0d9d5c40b5348fcab0f6f50159eed83b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67aa6f72141322d1d22cda16fa960bf98c53d2ef0af727f0930a9e2c92a90513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf072ececd360e53f495d890b676c0407a740dc7669bfe18b90b36bf5c6a6761"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"gci", shell_parameter_format: :cobra)
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
