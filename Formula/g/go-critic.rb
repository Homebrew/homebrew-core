class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "6cee82b801a849aef3adb714b7900d6df7b27213af984368be4c65db8400632e"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbb58266fda2c66ceaaf16a51f7a010d15a6a7f927f5452ed4b3fad9a7683720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbb58266fda2c66ceaaf16a51f7a010d15a6a7f927f5452ed4b3fad9a7683720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbb58266fda2c66ceaaf16a51f7a010d15a6a7f927f5452ed4b3fad9a7683720"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b452b6d835604fbf8ff06d9d812b73038940b9c8dd82212abc4957ca2de58d42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f8766044da085c70ace03cf8f7a39ec1f40c1e158f296d6f0f72e476aae1b20"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/go-critic"
    bin.install_symlink bin/"go-critic" => "gocritic"
  end

  test do
    assert_predicate bin/"gocritic", :symlink?
    assert_equal "go-critic", (bin/"gocritic").readlink.to_s

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output_go_critic = shell_output("#{bin}/go-critic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_go_critic

    output_gocritic = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_gocritic
  end
end
