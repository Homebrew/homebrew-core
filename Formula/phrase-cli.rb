class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.8.0.tar.gz"
  sha256 "d4b87434bdb63153473b29cdac821d622fb29d9f0d9f3ab51e1f72fb3bb7cc0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "424dd9851a367ed4e1336d62e80e76942d91f49ab1baf087d9bdbcbc8cda1de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "424dd9851a367ed4e1336d62e80e76942d91f49ab1baf087d9bdbcbc8cda1de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "424dd9851a367ed4e1336d62e80e76942d91f49ab1baf087d9bdbcbc8cda1de2"
    sha256 cellar: :any_skip_relocation, ventura:        "a58f12799316a3881708e501ac336fe8b0ea657eef10d137ae5e814ed058e9d1"
    sha256 cellar: :any_skip_relocation, monterey:       "a58f12799316a3881708e501ac336fe8b0ea657eef10d137ae5e814ed058e9d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a58f12799316a3881708e501ac336fe8b0ea657eef10d137ae5e814ed058e9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92ae7b9254e1e7109a586ac2a1cf8e699457897a8f58e0cd36bead4f382ed85"
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
