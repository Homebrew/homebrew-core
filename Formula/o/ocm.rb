class Ocm < Formula
  desc "CLI for the Red Hat OpenShift Cluster Manager"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift-online/ocm-cli/archive/refs/tags/v0.1.68.tar.gz"
  sha256 "2124955b157e9e3d46a50e08ba6c5c9e90a79fa09b7b3475f7c1364748dd474d"
  license "Apache-2.0"
  head "https://github.com/openshift-online/ocm-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e691ad518fa2bb90b7320bb3c88226f7eb264a2a877fe0f42a56abb6b553b66e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5f3d71be91bd1b70cd5e9c62a6a28c3fba3ae34a7bf391b8002a1668946fdde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c81f67ced7aec8c96b7d25c2ef1c7d52577bb1500915c861eacd5984cafa5c2e"
    sha256 cellar: :any_skip_relocation, ventura:        "93cccae407ea50b976e8484eaf6584c931d36c2ce49280adb6ffecdd8ff940f8"
    sha256 cellar: :any_skip_relocation, monterey:       "4770dedcc9b13669891efcbc05d53fd153188c9b2934688f134aca14c8021144"
    sha256 cellar: :any_skip_relocation, big_sur:        "81daa3f2e14d384939c2ffbbab0728af04b7dc4045364056e173e5ae21c92a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c050b4e14b48c92f55ce1039144cec8c5f6095005b850f890369ee25540a6a36"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/ocm"
    generate_completions_from_executable(bin/"ocm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocm version")

    # Test that the config can be created and configuration set in it
    ENV["OCM_CONFIG"] = testpath/"ocm.json"
    system bin/"ocm", "config", "set", "pager", "less"
    config_json = JSON.parse(File.read(ENV["OCM_CONFIG"]))
    assert_equal "less", config_json["pager"]
  end
end
