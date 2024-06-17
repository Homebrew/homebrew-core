class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.28.0.tar.gz"
  sha256 "89102ba99772def3f074d0627428604c59a7083935d7bae019870362c921c4b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b31d67651c89b76c7210d622033376dc2ba647dd1bf467c93676e207c6a77403"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79a0374b30b3b0f1bf51be0c3ea8b420c7bfa6fbbdedb08a52ba056c45d4b951"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f40b6bcc3606752bceae1e6b54e63c8c78d9750db6189bab360b9e9baa7e06"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce6feb33ae9da376328d0e01e0ada1eb2eef67270135af37b6c2bde2fb7c38e5"
    sha256 cellar: :any_skip_relocation, ventura:        "b3ad155e422c34bf1d4ec5011406704ad8d0baa903b87ba5baf542cc72fb8b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "048afcaea4a2cb81cd2f352567dc250f3b2164c7fff7f02c1f26e6c14ad90f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0b4c31731a2f1a4bb2ee7ce302989bff3f96addb78943607c93fad1763648c"
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
