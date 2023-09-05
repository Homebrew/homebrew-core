class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.11.0.tar.gz"
  sha256 "b94d21320ff53250d8de9b4942b032ce98e92dcba1e39a4dc61530d9bae3d62e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b6e1bf857df21f1af34b0b3eae7ec9637ac4895a22583ff6389506a8d115e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ce8e42ef3f9af7232d47b38184ae34a89b72090d2d28c3d39d82d12e6b85d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcc58196881f89a1f5e6866e3bf603aee73bd35dc136314187ab374568314326"
    sha256 cellar: :any_skip_relocation, ventura:        "fc9da3d68df0ca0e08c1bd493e723a6e60e20cbfc83aaf0a4046120ff98f5b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcd673a3a9aefff7ad51934bc9cbb217ec353f9351df7c562ba36e2f37a30ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4fcb1dda0c0a8588de9956be50b7648adb3d68234159f189ad76415e3fd057c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cc1e205c322ab1ebd2d43dad8e84009b312a7c8c6c99c0e56ac5b61cb3f208b"
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
