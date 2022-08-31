class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.6.4.tar.gz"
  sha256 "5a5863a534ba6a8bff2cec5e11cb7a503b6ab89d23b692172a445a82bbf2121c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32252bb033d70e7dead25b0ab9a6d1e66028ae582f8570feb206d11547af473"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8b04b8efdd6dfcd8dab3b9cabf23a886a14530d449edd4dee89ac5cf6abcfa2"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f2b084d70ca1d859fc14b39a11c9adf1b42bcd425ceb18a9c538afd2d22805"
    sha256 cellar: :any_skip_relocation, big_sur:        "942ebb3d0ec46f164f5ba4f5fa614bf516a12d05ed109b9b193803498db4b565"
    sha256 cellar: :any_skip_relocation, catalina:       "0b6f1064a8e9459f1a88a112a531fc3d057804191f1322921e749be900a12c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd9e95db97669f25ff85e7a5c5a9dbcc9534e1f343377797ee8de2bb1cb3cd7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
