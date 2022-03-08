class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.7.tar.gz"
  sha256 "e958e6e31cf7f04f082939322875165d38685e1a2f59334733dd47c44c19b747"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8087b8c013939e733b89a8fd986f398f3a09eb717a05124361cd51412284991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7e2af5c704497c70143742c2eae646befa616ea55b16d56737263cb9154533a"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe83d45e8dd146e277f5be4322d8d76cf9c32a3db63af4a9a5ab60997a8518e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a98ab598c54fe5be3c61b05b68d96dfc578f4bf1425d40ccb746569abe9fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "1dbf604bcb4763ea2b43f3f3994139cbf369e86b79537cb61e8da33fe67209d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d0df3c8fc619f614401ba7b9c050fbd84705a12badfdb5cfdc3859494a23f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/action.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -d \"mysql://user:pass@tcp(localhost:3306)/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
