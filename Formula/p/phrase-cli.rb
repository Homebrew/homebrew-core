class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.45.0.tar.gz"
  sha256 "127ef4540ac374868fcc430c1ef15d0843282d4b4a6026cb71182887c4826919"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d7ccfa5dca1fa8db9a410294c47ac1d72b64ac47f55552b2aee49ebbc8792fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14bfd0cdb3564be00d296a358bfaf37fc83f7ad0c7d1486614f306d566a31db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14bfd0cdb3564be00d296a358bfaf37fc83f7ad0c7d1486614f306d566a31db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14bfd0cdb3564be00d296a358bfaf37fc83f7ad0c7d1486614f306d566a31db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "83934233d3f76c7db0226457fdd3a0a42c900efd8f3d5479a9451113c0e1c81e"
    sha256 cellar: :any_skip_relocation, ventura:       "83934233d3f76c7db0226457fdd3a0a42c900efd8f3d5479a9451113c0e1c81e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56e952ca038b1de1238da40c7270f64cbf2942763bd02aa4968cf3099385d5da"
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
