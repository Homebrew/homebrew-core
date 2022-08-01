class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/cli"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.5.0.tar.gz"
  sha256 "0705b479b4e546515c3c7ccd45aeb629f3a43f8dc18038c3c33ed792aa06614f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c4ef3d9d2ea22aa4681ee7b65ec4947b6cf1afa761e901e9f7edc82e979bc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec88db22bf86d803ad21f6ba38d0fc65f01e3b6a069e6fb72c238ad849657772"
    sha256 cellar: :any_skip_relocation, monterey:       "52677eb884c6e24297a8f2acd6a296a7162d5eb83f528a7a57615659e2f2e373"
    sha256 cellar: :any_skip_relocation, big_sur:        "06830a601514fecb63525c6e1b11b3777fcad0e4bda772887d92c6e8016e91de"
    sha256 cellar: :any_skip_relocation, catalina:       "8ee764e04803f08c73cd909635b1e0d3b2f3d980b09839420a04c42b6d700e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fecc5702b2e82cd17f55511c5c13189e2e7c1ca49b563d2c4b7203e99fbabfbf"
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
  end

  test do
    assert_match "Error: no targets for download specified", shell_output("#{bin}/phrase pull", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
