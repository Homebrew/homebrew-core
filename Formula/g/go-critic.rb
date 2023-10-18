class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://github.com/go-critic/go-critic/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "d2e266aa6f7e7390a12144c159f616a7eaa2c37a4834a169b2debd33e601467a"
  license "MIT"
  revision 1
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a9e3b34f56a4617dea67cbc0959f69f8c88833fdf05035de344e200b4e4f99c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "751a7ba33d429ec2457ca8ba92275cdce9b15bc234ea8fd962ca1b5869bd6461"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "751a7ba33d429ec2457ca8ba92275cdce9b15bc234ea8fd962ca1b5869bd6461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "751a7ba33d429ec2457ca8ba92275cdce9b15bc234ea8fd962ca1b5869bd6461"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cacf6d3ad070b6ab22aa2f6f01386d3ecde6694162e18b28c753e0f5e91bbc0"
    sha256 cellar: :any_skip_relocation, ventura:        "643274fa569b56452578647cda64676c9d53ef5c22c02d83e0399e2bff6696f7"
    sha256 cellar: :any_skip_relocation, monterey:       "643274fa569b56452578647cda64676c9d53ef5c22c02d83e0399e2bff6696f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "643274fa569b56452578647cda64676c9d53ef5c22c02d83e0399e2bff6696f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1ec677c594afe79f413acd26cda65a4ad74ffad84f7bf9c173af2aa71c01e9"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"gocritic"), "./cmd/gocritic"
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    EOS

    output = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output
  end
end
