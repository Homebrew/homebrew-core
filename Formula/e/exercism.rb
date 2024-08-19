class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "da68ad169e23d48e2372b73891752d1cf1bf333fd82c9a4206abd05374233999"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb7d247a8d421807bb29589db406f363a23c101ec324b5897da9ec4910091eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea6ffb3faba0b8b33be67efb0c4ecaaeadad429e37925972d764477c007b884"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f03348fadb9b4aa61f315287d52e185d14a01ea98be06c2e3553c8f1aa512d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f821fe1e57d7b7847cff19c30916c91bbe560d000c982bb9ae21493132daff96"
    sha256 cellar: :any_skip_relocation, ventura:        "f099a8d2590cbea5f0d6cf374e8719ab9053d3d2bf945f9d5887860dec995dca"
    sha256 cellar: :any_skip_relocation, monterey:       "a50a88d8ab42c4fa8c36455c7fa56110003e12eae40b0ae058e3b1d17b28dda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aaec6ea8f5da36276ed0dd460117e6e4924e93e134558028f49db9a3fc529f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
