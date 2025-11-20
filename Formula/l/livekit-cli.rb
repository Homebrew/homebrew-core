class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.12.9.tar.gz"
  sha256 "77dea4243855402e7f22e0cb66681586656fd1cddcb7ab5723993ab48369cf58"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "284aea9e772c13f71bb59f7b54fd5a148d809ef738728d5be0dc8c29e9b8afb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed8ecf0c76e640b6bd75a25e984e9ca5910f2dc6580ae3aa62995e061568e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a678210277a1c89efe28fa36e1220ebff3b9545c051acf0229a0091a65a0038a"
    sha256 cellar: :any_skip_relocation, sonoma:        "79cf274f86279bdaf5c987f7d9711d16a217f1ee9e80c30ba38d3f7f2f00fbe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ba6a69a2f5b7b742bebd26ae11b7618659351791c709d86f4c8295db08e51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91d9bad2fc0056844aea932966bd8dbba4411bbbfe6f27d8cf59b97c0352158"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
