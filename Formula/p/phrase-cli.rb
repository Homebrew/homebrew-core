class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.76.0.tar.gz"
  sha256 "0f7a64580be405bec61c7f29ac85aebce463005dd53720edc72cfab9c58c71d8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "11fa5224f4e7e36b9d031bd76e28c0c17a98c5e93d378566cabd77df6bbd0c71"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb4b3ff1c74addf5515476ee571f56e6ed9a077a61b919d9b90982add79c2af9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bb4b3ff1c74addf5515476ee571f56e6ed9a077a61b919d9b90982add79c2af9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb4b3ff1c74addf5515476ee571f56e6ed9a077a61b919d9b90982add79c2af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a57fda04ba8abf5879b0ae5d94415d751bc5487b7bb0d912444324bc242cbcc3"
    sha256 cellar: :any,                 x86_64_linux:      "ec1ef80572f4218d433894a6126d01bc7aff0ec45e94d972f207d6f47a49ff34"
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
