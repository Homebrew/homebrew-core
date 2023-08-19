class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.8.4.tar.gz"
  sha256 "a14ac39d1dbda17258da2c845a08991b883550657c4d40654940cde183b3f709"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcffa2e1c2e8f34c05c051ed5a7b6831b5f76d91f4acbf062064da3bc3ee4cb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcffa2e1c2e8f34c05c051ed5a7b6831b5f76d91f4acbf062064da3bc3ee4cb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcffa2e1c2e8f34c05c051ed5a7b6831b5f76d91f4acbf062064da3bc3ee4cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "728c824f450bf3be50496b9ff3eee8aa1f08b2cc53040a92a5c01acc39a4e937"
    sha256 cellar: :any_skip_relocation, monterey:       "728c824f450bf3be50496b9ff3eee8aa1f08b2cc53040a92a5c01acc39a4e937"
    sha256 cellar: :any_skip_relocation, big_sur:        "728c824f450bf3be50496b9ff3eee8aa1f08b2cc53040a92a5c01acc39a4e937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6503d414fc3edc73d7da397582d3a6ad41ad97835605cce417e5daab2574d42a"
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
