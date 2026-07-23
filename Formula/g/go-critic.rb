class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "03c19c7a0d1ed931ae1f2c227bd881725d520f4767ccbbac0085644f69069094"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1123df5d5711bf6f005df489e7f66c9c192794c7b00b63bfce7a0c5fbcd1d4a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1123df5d5711bf6f005df489e7f66c9c192794c7b00b63bfce7a0c5fbcd1d4a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1123df5d5711bf6f005df489e7f66c9c192794c7b00b63bfce7a0c5fbcd1d4a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1267fe903802263093baf96fedfbcad261162edda114ec8e997dafeaa78e63e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa6fdc0733df99213934dae11c0dc7481bc23f28002401d194bde79f9b9fc72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c934c58d55908dada47c2d79605383bf780878d0473c1aad6c021fc9338710f8"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:), "./cmd/go-critic"
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
