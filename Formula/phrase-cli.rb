class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.9.tar.gz"
  sha256 "b773824c4dc8591f5a408f9946f1d3f19142f43d05e0b72d25760bdfcf0562d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edc189a1531003788ae5b7812b1c22f2d0fea78437b352498d1fb0629b368409"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edc189a1531003788ae5b7812b1c22f2d0fea78437b352498d1fb0629b368409"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edc189a1531003788ae5b7812b1c22f2d0fea78437b352498d1fb0629b368409"
    sha256 cellar: :any_skip_relocation, ventura:        "7630ff0c0fac6f3089141eaa4d32bb76f1364f908002513c95567377284ca16b"
    sha256 cellar: :any_skip_relocation, monterey:       "7630ff0c0fac6f3089141eaa4d32bb76f1364f908002513c95567377284ca16b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7630ff0c0fac6f3089141eaa4d32bb76f1364f908002513c95567377284ca16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "986a4b53a8a05d779e0f1e18fd75d2e05270ae5fe585acdb3b53d573e0962620"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
