class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.39.0.tar.gz"
  sha256 "f0070acbea6c569de32f16134b14daa87b6cd8978c76703f582b1c092aad377c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7be851b3f7b1ccfcf95e2b7dc2806b806f84fcc3e009c0ebf41b04a0bd5bd02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7be851b3f7b1ccfcf95e2b7dc2806b806f84fcc3e009c0ebf41b04a0bd5bd02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7be851b3f7b1ccfcf95e2b7dc2806b806f84fcc3e009c0ebf41b04a0bd5bd02"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20fd79a08789e76d7535337bdc453ed00a14f1b46c908e443a3a46f5ebc9adc"
    sha256 cellar: :any_skip_relocation, ventura:       "b20fd79a08789e76d7535337bdc453ed00a14f1b46c908e443a3a46f5ebc9adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3999dc5dc38e2315be4ba86d302bd2b1c239c63a564eb066fc1b83856e875383"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
