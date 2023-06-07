class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.16.4",
      revision: "ef9c472c5ff1d7fe4a0c8f8e1d8c0146f836a894"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b43fb9ae5ad9dea01a3ea445671117492d0313270f95341cdbdfefba951652b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2e0d85cb52209bba7a4e17e1842bc106a25a8100d7408cdfe25811b524c1f50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dac024d5c5c32d8a9b47ce578901a0afa8c3511697dd7c2d12f3b1a6342e3f2"
    sha256 cellar: :any_skip_relocation, ventura:        "10d142d8dd3db833939b387bd19f5eaa12f907cf4ad5e2abc736ec0a496fe308"
    sha256 cellar: :any_skip_relocation, monterey:       "15b3326368b5f50356e6a35e064e9d4136a3a2d947adfc0673c22bbfca11de95"
    sha256 cellar: :any_skip_relocation, big_sur:        "a782a5f97a2223abc670daee00ee2ce6e5fb6d393b587e3ac919d286e7b699c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "012a3f58d42229952546158b5583e1fc7d261a0d4bff88dd209981b0295d59f2"
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
