class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.13.1",
      revision: "fb1d6564b61605be8014c78f0ad9942b6fda4230"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "339a79bcd1aad57a181bf899acc45e7899ff171da5bcb12791ff562d7c494a4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b383714c5cfd1fe5ce83f999613fcbd6bd1470cd8ca74aa133f99515e5c520f8"
    sha256 cellar: :any_skip_relocation, monterey:       "42820393c085a5c0ae4ee4ed8df39794b6f36db020eb4cbad9d8a19a17620359"
    sha256 cellar: :any_skip_relocation, big_sur:        "af054bef94a7307f158d8dc46b679c8ce29e77548f5edd03eb763f8795e609f6"
    sha256 cellar: :any_skip_relocation, catalina:       "0cf98bcf098ef2027f2058f1bb44847aa65ff6876df9ac7cb7c35a3616391b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253737e49d2a398c67211b250e1750bc3e463789daa38889fbc848238e473e19"
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
