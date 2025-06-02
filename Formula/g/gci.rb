class Gci < Formula
  desc "Control Golang package import order and make it always deterministic"
  homepage "https://github.com/daixiang0/gci"
  url "https://github.com/daixiang0/gci/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "89946f56773269dce0776b5c6c978790ccf006c116c9692f545500dec54affdd"
  license "BSD-3-Clause"
  head "https://github.com/daixiang0/gci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3831ca85a8c9143b1eaa2cb0925078f2c7b0a6efc12f6e00a30419c9d88ae964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3831ca85a8c9143b1eaa2cb0925078f2c7b0a6efc12f6e00a30419c9d88ae964"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3831ca85a8c9143b1eaa2cb0925078f2c7b0a6efc12f6e00a30419c9d88ae964"
    sha256 cellar: :any_skip_relocation, sonoma:        "79bfc67c8457bd743262701889db578835c69709a757e340f22e6dbb89f5195f"
    sha256 cellar: :any_skip_relocation, ventura:       "79bfc67c8457bd743262701889db578835c69709a757e340f22e6dbb89f5195f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a1e1cd4652c79147e3940b6022b64d3e468baeaff0fa6d085341d455ec3335"
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
