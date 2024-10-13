class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.33.1.tar.gz"
  sha256 "5b68b4c961c459073ecc1f8e3fdf275e9fd096433ef00227852265a8c50b387d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23af1b2f778a0f0e2233cae57f19f7cce6ccc7b9b7be4bc7f9331d143b588a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23af1b2f778a0f0e2233cae57f19f7cce6ccc7b9b7be4bc7f9331d143b588a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "23af1b2f778a0f0e2233cae57f19f7cce6ccc7b9b7be4bc7f9331d143b588a12"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d555d5c7e2b2dc89e1d71d632b134699b0f63ca22599b913a2c11c2ba931e0"
    sha256 cellar: :any_skip_relocation, ventura:       "74d555d5c7e2b2dc89e1d71d632b134699b0f63ca22599b913a2c11c2ba931e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e43b43244dfb7bc3199aee3991711b49e02b6efdff8856aa7e1cdd8a442198e"
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
