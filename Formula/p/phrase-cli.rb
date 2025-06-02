class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.40.0.tar.gz"
  sha256 "1f2000c179595ea5e8c86ae4e8d20f07d0da37e320dddaa96c8c397faba0862a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70445e1015d456dba6dbd17af6682bc9a598d3bf9f384980c608e2186061999f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70445e1015d456dba6dbd17af6682bc9a598d3bf9f384980c608e2186061999f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70445e1015d456dba6dbd17af6682bc9a598d3bf9f384980c608e2186061999f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aff19ebfd35bd814f216c6d45e1e774cde06b5fc57926c8038ccc5d1494057a"
    sha256 cellar: :any_skip_relocation, ventura:       "4aff19ebfd35bd814f216c6d45e1e774cde06b5fc57926c8038ccc5d1494057a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6d96a733d7c89397ffdc66ed0e329ff51c0cb3be9a3b7bd0c919d75b75caee8"
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
