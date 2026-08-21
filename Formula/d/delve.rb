class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "dca9ec6f2c392a00449ad748b3a229e92ba4efa67f4e7582f2cc45974429928f"
  license "MIT"
  head "https://github.com/go-delve/delve.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ac0e5294e2e25e71d7a2ed927ed042817bef29a6a141d57a5fcd8acfc62ce2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac0e5294e2e25e71d7a2ed927ed042817bef29a6a141d57a5fcd8acfc62ce2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac0e5294e2e25e71d7a2ed927ed042817bef29a6a141d57a5fcd8acfc62ce2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cc967a17c14b5195fd1f20e06c0d018ecf309c140a47c8289036f770fb2375f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def0eee6dd0963c8648068f8c8464b9dbc2507a3930fa62591da8383e1bf204e"
    sha256 cellar: :any,                 x86_64_linux:  "eff00cdfcf9dcb6967dc8781ed7674cc52be1c4384d28536de533659aba704ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"

    generate_completions_from_executable(bin/"dlv", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
