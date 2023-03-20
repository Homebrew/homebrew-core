class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.7.0.tar.gz"
  sha256 "8b6933d66b97e51131c4a1a8a8a80bf00b33de4e5730431574ed25735e4d4c6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "470a2e28c47383656243d65f6484026f394649da1631e2300f01996e4c024486"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470a2e28c47383656243d65f6484026f394649da1631e2300f01996e4c024486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "470a2e28c47383656243d65f6484026f394649da1631e2300f01996e4c024486"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a193fc1bd608f1be40c771242296f89eec92532ae68721f9312126df926679"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a193fc1bd608f1be40c771242296f89eec92532ae68721f9312126df926679"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4a193fc1bd608f1be40c771242296f89eec92532ae68721f9312126df926679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c30b477f7cd70106cbbecf2e82248f549f99c8ff53b094f421a1980d1963e3e"
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
