class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.68.0.tar.gz"
  sha256 "82abb47e48d45fd3fc2e667754502faf612f35db039c35c63a963c49376e200a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "396d718350f77dca9c79cf3081e1d42c7db646cc114a455bee290a89bb358064"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "396d718350f77dca9c79cf3081e1d42c7db646cc114a455bee290a89bb358064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "396d718350f77dca9c79cf3081e1d42c7db646cc114a455bee290a89bb358064"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94e52125d93fea5fae890dce6f1615dc622210da02c105e20a0a01589af5476f"
    sha256 cellar: :any,                 x86_64_linux:      "7a472176fe0fa4788bf2de22774387b8d1ea97887e3d88ba29471bd0760c3aa3"
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
