class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.35.6.tar.gz"
  sha256 "d29adb2bcea498127d4c0cb6a441ec270048774ee89caf6dbcf65b74ca162e4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55e23a85e0e3d97d46cc1a661a3bafa36e253050ba8bc5ac0345d4c5a96e03b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55e23a85e0e3d97d46cc1a661a3bafa36e253050ba8bc5ac0345d4c5a96e03b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d55e23a85e0e3d97d46cc1a661a3bafa36e253050ba8bc5ac0345d4c5a96e03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f155f810cdbab5856c33d84fc6baf07fe0cb0bac10531e2116ca0d5b6af4e86c"
    sha256 cellar: :any_skip_relocation, ventura:       "f155f810cdbab5856c33d84fc6baf07fe0cb0bac10531e2116ca0d5b6af4e86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f289b5c3929b9a09ec6fa74c3f0175ea130fc11311fdbdd8d1d66143d49599b"
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
