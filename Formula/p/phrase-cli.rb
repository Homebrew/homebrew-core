class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.67.2.tar.gz"
  sha256 "406bd69c742b8dd0667a29e6eb97bc71de8c57ff13a5f4b0d833f041e1b70633"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "67341f78bce23e46cd62f0c2540f8aa0ceac5ff561b394413f0f130fdfc443f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0dc727ed2caf1393beddc14a30d4f9fceffbf67d7e2a5ce78c3247a7a4ce9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0dc727ed2caf1393beddc14a30d4f9fceffbf67d7e2a5ce78c3247a7a4ce9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c0dc727ed2caf1393beddc14a30d4f9fceffbf67d7e2a5ce78c3247a7a4ce9ca"
    sha256 cellar: :any_skip_relocation, sonoma:            "944b76cb08b1acb1bc43febeace6f018d205ccbf08050bb7a1f226fde0a9f6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "307a80b47346a7a045886f43b7bb3c485a9630e008e6930263e85fa07f3eb087"
    sha256 cellar: :any,                 x86_64_linux:      "e82007f57fd4eeb3b103cb88a900637a64e5970f400958f462b3a28c0c0cf085"
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
