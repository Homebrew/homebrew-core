class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.22.0.tar.gz"
  sha256 "575eea8afe9025720310578e0f4791f4bc1aa4787435b78e6f96967fbdc6470f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff0caa77d914e2eb7679baa3bba38bb7fef444e1dc87206d02479f79af338bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76b4631bc69293db46707312c967437c80b2bf993cc5060317f5e9e136a96244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53816d3429fccd8efc9d6bd8749c18eec51eda3a55c991b5a6106fa6e4c79a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a57a7e383370f0e8ee701fbd4dec7f96e5e29ce60c016e97e7e6450fa22b0c2"
    sha256 cellar: :any_skip_relocation, ventura:        "e6f5c38d6e13ce95c8d20a0301eb89a5e286e6527472a97307bcd22aa2100a06"
    sha256 cellar: :any_skip_relocation, monterey:       "77ee880be1d72cfae43c8aab04a723a27a6b237228f2ad0f3a73f197aedad0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d9cd6593bc27573683a653c8af37cf70bd469044506b24c9a68bc4b0683a0ef"
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
