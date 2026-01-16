class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "0aec9ddf773fd5b4314e467a0b9e08178c39f4403905feaa7711873f0df44ec7"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f95f2a94a799a8565a2a238265957844b736cd3dc193317511412bd4680267b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59a9893a573b0920eeb014c1ad7057b4175d671e0a34d326f35673e1cc0acc85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677bccdf6a195e1c052417d6c75d2a85fd41916e2f84acaf65a2b55733d3f236"
    sha256 cellar: :any_skip_relocation, sonoma:        "ede018ff5c3778615ffc5570b820d1c953b34abb05263f1df6bc2a45700309fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "158b4a8ef3de80787937265dba0c019204ea3f8b1e7613fad02548843dd3dfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15dd482d67cc0fde825a4bbf1cd6674e97ccc048ad08698ac90d792d738ba9cd"
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
