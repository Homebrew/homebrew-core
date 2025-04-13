class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "3d38b9f3f8c75a2ac5917ab2dda0a6a89a581a75ed755aec698e931611979223"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0971d5199510dea4a17e5d81b5dcb9c1cd663b22a6043f3b2ac34ebaf5e0f057"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0971d5199510dea4a17e5d81b5dcb9c1cd663b22a6043f3b2ac34ebaf5e0f057"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0971d5199510dea4a17e5d81b5dcb9c1cd663b22a6043f3b2ac34ebaf5e0f057"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a09d5e396be8bf3ac812ed61250b6a5e1354bf887099618669924aa5893355"
    sha256 cellar: :any_skip_relocation, ventura:       "79a09d5e396be8bf3ac812ed61250b6a5e1354bf887099618669924aa5893355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1e7733199b192aaeb2aa7bf21b41afacbf1eed5a26532164ef3a917f7b8feeb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)

    assert_match version.to_s, shell_output("#{bin}/kubeconform -v")
  end
end
