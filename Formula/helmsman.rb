class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.15.0",
      revision: "2b0f8b7a4b9e4907bfdc36af2636b15e1f99270e"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547843b450daaa2473f27c3da439b498931e0330a84706f80722a2bfd6c5c23b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "475b8c6bc90b74e9c4fe4f87a900157653198b70f38435fa8e3e99c0fdf29c55"
    sha256 cellar: :any_skip_relocation, monterey:       "58dca1573541788be0f45f5b19a427da8c128824518c2142e65b567227412d81"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a2fb4c1afb2e927b09b2180ea4100ff4c08a767796a079680fd77ca5a3a4f28"
    sha256 cellar: :any_skip_relocation, catalina:       "adc338a424054fc215852cd568308cab563e4ab7ee4ba21b7613085c263df4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d599bcc6bfa67e8c372a94ff136eb5c04022fe351acf997e3640b1eb0bffa8a1"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
