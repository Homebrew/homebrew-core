class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.16.3.tar.gz"
  sha256 "56a840b975097582e3d9b996eed58664909e0e3ac457261f2f004dd3be77ed4d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "658fe263e9e8aafe4d5a87c2e5a411621d057ad52b8eb3fb28b508e0fcf2c2f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c72ce9b9c7c6057af3657838afc7bc9b137d5057f41ae4da1234a9649c27dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6739b429214bdfbbc2eeae8d5ee60e6f227c9f7307fcfac6760180b5047d00c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f9682c63fde83afbcb9a7b8c9393c95666bd9753d8ae99263e81e98993d26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f352e3ba10aa30a7a838ebcbc594e467586e424509988d10beb2779e11096429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415d3fb1c90b38262e49bd800f00d617be866132f28fbcd0eb5fc2d2f2a664f1"
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
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret 2>&1")
    assert_match "valid for (mins): 5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
