class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.3.5.tar.gz"
  sha256 "005c0108fc92355a7a7c9df98dd18062a3575e970a5aa992d7a0a731a451b49c"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337c291e8ea39e766bd7994753f8ae2a340bbb26f323e3ad73716edefae6a64e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44c134efad6908adad0fdf35b0fca8a36a86a267060af4731f5287a081a75e36"
    sha256 cellar: :any_skip_relocation, monterey:       "6d700e558f21125f851a52f5f1224e3ae9900c2855fdb32b341aca1aed457995"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf0b5440e7ba0365057f9bfa00ef8726799e2a716f24c289a894e5201d8fea2"
    sha256 cellar: :any_skip_relocation, catalina:       "f7cbb0bbc12f8952ab8df50abe0d0de2211a1cca1ac30a71fa6a075206cd0a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "556aa1a6ea851d4125bc6833155c4f90f70e0e96de7d33d2e3577f76cd35f868"
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
