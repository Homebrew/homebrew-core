class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.8.2.tar.gz"
  sha256 "e1b479ba88a08595630904de5e9bbed9154b61fa449359d61f41e50f5c512a43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83614f053374f5ff98458012fe927a79399de5383111d005e619d659dedee411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83614f053374f5ff98458012fe927a79399de5383111d005e619d659dedee411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83614f053374f5ff98458012fe927a79399de5383111d005e619d659dedee411"
    sha256 cellar: :any_skip_relocation, ventura:        "0c0170fbff8cf9a940c036fcecff796c166a73b3531cf51ed787349fb8510fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "0c0170fbff8cf9a940c036fcecff796c166a73b3531cf51ed787349fb8510fe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0170fbff8cf9a940c036fcecff796c166a73b3531cf51ed787349fb8510fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af0fd8eef4538e7d4226e120c017ef457ca916bde42ec7476fe2cd19995675e8"
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
