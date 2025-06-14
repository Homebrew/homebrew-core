class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.11.tar.gz"
  sha256 "b09134d4cc908c7a7d5aed8e7b46ad016c606b11caf6b9d19ec33a139fac190d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d61af9ce23289287ee5a924bc305fec9ab6e4dc89e83636dd46290c70143fef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "652fd8b337c53edb6b585106e0ac58a8e354e17a4b8a60b99a6a61e057bb98ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87dd441e73d594f46579045b7aca9988677a538aacef36b1c122def3af6933b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e6c78937fd9e872ec836cc325b4d45ad111e1173c9ef22a5f83543f820c4a63"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a789ede296cbf110d38c0975bc10f7138a054998506dc1beacafb27443fd8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a253b9a0a7ad7ffaeba871dfce0a2f3017e16b34446ff54aa4e27361dd1557"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https://github.com/livekit/livekit-cli/pull/596
  patch do
    url "https://github.com/livekit/livekit-cli/commit/8e7e8070891df936b93a9fe2be65d0b3006ec76a.patch?full_index=1"
    sha256 "df5c8bb76e062ac7b7102419033ea4f38a4b897db64dfe8fc84acc2023b1682d"
  end

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
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end
