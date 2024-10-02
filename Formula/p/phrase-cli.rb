class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.33.0.tar.gz"
  sha256 "50b0452fe898845d89ec7cbcc47a4db69636f1d778f9bbf71f44ab6826f07121"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd6c7a3252ec1e1f200f8fb5a53da60964aa07246346ba74be079b2f502fe86b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8492b78eb43b5d9c1e69e42272d29a12e62b07302bd56134925503968f0e89"
    sha256 cellar: :any_skip_relocation, ventura:       "bd8492b78eb43b5d9c1e69e42272d29a12e62b07302bd56134925503968f0e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd5994003f5288f37ef339f2bc1ec9749141d6adf753e56fd17a16336d5b0205"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
