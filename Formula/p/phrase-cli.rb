class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.71.0.tar.gz"
  sha256 "8302be1fff596c9d5da0cba82c1a4697dbda38a7140eea1d9238e6f186da282d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a066d0c1a0052528731bade992114edd8913ea555cf741e22fd8b662c303d1ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a066d0c1a0052528731bade992114edd8913ea555cf741e22fd8b662c303d1ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a066d0c1a0052528731bade992114edd8913ea555cf741e22fd8b662c303d1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a5702d47941f9f7d671951aa79786c764aa0df1841513a78d69b3eb1e3f2022"
    sha256 cellar: :any,                 x86_64_linux:      "1b83553ac071364a0566a5f7cba49cf89d507e0a07780f9d299c557f3c6439cd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
