class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "9f3477e3e41c7f1aeca67471c9687594ea5c2876e637ea6010809e79a67f303d"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cbc6babfaffc5d9646b57e3445c13140d94f792fcb59917711347b4a7dbbef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90fb15337b08cd3003d972b0eca5f4e330cc3d044a18b5d224bbb4de4fdf0e9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "004c796ca4e0f3efc16c9b40a37e9a18dd1acb781cd747694d40620a36f06edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "100dd2e1fd4f6b44bd3dec6aaf066184a4f992d984f7a0310a26d7da296781a0"
    sha256 cellar: :any_skip_relocation, ventura:        "57ae6147132e107d18768ac1599d603f0fe863bfee7a50c82701303cc88b49a8"
    sha256 cellar: :any_skip_relocation, monterey:       "4baf12e5bb06ac3bd20699014f92056e8cde3c6326636eb0e549818a7edc49e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db9868777e9244becec80dda6504c19b844794c9eb565f1289c58c90486d698a"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
