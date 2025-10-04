class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "ad4710e0cb1ebe20c929e68ceb4cccc7c509fb1880268cf1c1d82af3458ae34a"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da6b9870325302333cdb43de18dbc00400525d07df0bf85621e39ae7fd6300e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7758ba445bafddb4984fddb4f6ea9d2b5c2aa7d02508186868437e56873019d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "443511a81c71b14c1f313e11bea0157bad247a46de74450dba48da2c243384f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ad8cfd97993ad0ade3c83dc530d1cb268db81094a264099f1d9d6c57a4607e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5ddb2b4530361094ca09c5a143e8afc54fc4b226a777bc18b6989777f1e36a3"
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
