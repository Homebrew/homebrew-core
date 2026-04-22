class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https://github.com/daixiang0/gci"
  url "https://github.com/daixiang0/gci/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "433d6dd89ebcb9f928f91729b9243971f6233970f78efc41ae672fe376de4e88"
  license "BSD-3-Clause"
  head "https://github.com/daixiang0/gci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004995409069782b3c3f8347ddc9cf8895a282abfcd2b6bdd16f53f0fabbc26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004995409069782b3c3f8347ddc9cf8895a282abfcd2b6bdd16f53f0fabbc26a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "004995409069782b3c3f8347ddc9cf8895a282abfcd2b6bdd16f53f0fabbc26a"
    sha256 cellar: :any_skip_relocation, sonoma:        "14cd5ae2da5a5c573cea93d2bb76d20f0a1e0359afd03b21bb2d070d955da57e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "502bc7e32fe6d7524c116a8936111c4d3f2d7cbf8ce59de8aed0cab091a33b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2514f7cddb033f9ebdb2be7136861c0bb5b7f80d5dd30b0cc058e32cb465c6"
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
