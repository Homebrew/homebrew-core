class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "35b55b79764589429328c639a0505d7e2dc45abfa1dad028d9fe0360636b3b5a"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f2f5b36678dfd98a4164d39e0f83249976e83336c6a934260da7e056c53c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265178ebc14f011da0909663c86a9cd26ab87dcf9a70acfe16aee930f9dd995f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "796dfd14af7ab4ca09df77a5e2762769d7150e04f8aecab355d806a626e83c2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a0194ed0cc8fb74b985e75f971412625db0b7e4b4d9cdabb4696930aa7fd665"
    sha256 cellar: :any_skip_relocation, ventura:       "acf6138317c218ca6d2eec374210c2dc34d69093b35e652342b0dcade34172e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "def7166578daebb8f96ecd9c9ef9b71350c6fa4693e11b8b98a3ea18710bf444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027e1b307871a24aa03e0478f58dcf2e52a3adc4b390adc4f3f3a3ad4bdbedad"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
