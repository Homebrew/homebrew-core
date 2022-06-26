class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.4.2.tar.gz"
  sha256 "d950e9f665cfb8b556c4f921e9d642e9628c1c8c788fa2b5ef9ddcb32d8751e6"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded53355913bb739005d6f7fa17765db3d669da89b732146fc410173925f2c1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd014013f8ac0e92a6bed45390f6d7e8da93576a694ff7694b46ef0c463c332"
    sha256 cellar: :any_skip_relocation, monterey:       "847674e5dfed0318af4a76c6cb9cb5caa4205ea65afce31bb281e0459af4527c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f500b7cee6dfd11f5cf5fb729996c8ce2c36cb325ed5f685ef39192660ffe6e"
    sha256 cellar: :any_skip_relocation, catalina:       "caf2f1c780f6c0ff2a9bd215a936f50174d612f1104921c7efe7c6c39b52bccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b073b66a1ca0644ce41c60363ef2f3ff5aa35156e5c5ff989eeb4a4074be2a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlascmd.version=v#{version}
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
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
