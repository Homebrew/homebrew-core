class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.12.0.tar.gz"
  sha256 "d97760500a4dd53629d320daec4275ae7272d3f013e08151265e4ec4dd8c3b5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098f153cecbb17aed8447160a2c489a7361b196e74aa3fb01f50589c98566b5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd1c94e7338d717e81f63fad2db4f5436313e3ec2879147c7482f840c13191d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4633343ced3d9bfa4182df7d1c4edbea4e1142b78fa88bea918db5741ee3043a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "847c45e420b560799981f84d1f1c39eb05a81ecb1d15b8a14ac706e264d6a0db"
    sha256 cellar: :any_skip_relocation, sonoma:         "574c476069c5f6a635519613741f09d50f91d34f4089c974422e2064eb4deff8"
    sha256 cellar: :any_skip_relocation, ventura:        "57269b4916b4efbc1ab800d25b0f1086bf35850abecce85fedbf1a1092b54161"
    sha256 cellar: :any_skip_relocation, monterey:       "0cfad640bed0d5e253100c8d459f29545fbb8051e342ffb33dc8ced4e3f1b2f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "38e57ee4955267be72d981ad787737ea0a156cbc0e38836148f438c2bfaed233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94720ad4a49f71cd1e65c91586012f0de363dcac27130e67fb35e1c946359892"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
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
