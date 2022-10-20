class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.15.0",
      revision: "2b0f8b7a4b9e4907bfdc36af2636b15e1f99270e"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5edc0c31be6f7ea21107b9274ac365f5b084e2feeb57d16e0395f50a8ce54ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93b59ff87c967894e13745cd622df84863effb404d7e93c616d8e90d1ae3e36b"
    sha256 cellar: :any_skip_relocation, monterey:       "2356cf2e9f6cd85ee3ddbb8be3c82e1879949d6555678839d48382ec4ce9b984"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc08100d0b5140f0d74c4d05ec89304a97b53ffe8f27b9dd7e8c351a065058d0"
    sha256 cellar: :any_skip_relocation, catalina:       "93ce598f470902ff6948a1dda6550297b7f902caa415d1cbf63593e172f5024d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f26b548409289c9f555ff8d55cb54e4fb2d131ab9e6daa8656fa394874f25e7"
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
