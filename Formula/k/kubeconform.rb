class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "3d38b9f3f8c75a2ac5917ab2dda0a6a89a581a75ed755aec698e931611979223"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9299dd255685b85b9a6c9e2230ce3a8e8370717a4a75c141dc6d7b26ab3951a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d6ddef665045d43c94cf2b8717ef072e161e614d42674648c181aac4d2987d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e2b9ceed38c66246d80ff5e266a7da28cee09f07be700fe6c21fe0e22ef3e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ae62caf12452ef0e925d92a6081a6a5684a757b5575adff826021bfd154fc10"
    sha256 cellar: :any_skip_relocation, ventura:        "ed5cf861eab09f6a297c8797fdec584555095d12a60439ed1ccbf8f0a7f11bcd"
    sha256 cellar: :any_skip_relocation, monterey:       "25ff3e90617a97ebae91009127b3c71ba393554d4e7dd3f525f47c5cedeee713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161bdbd38289ca34e13dea30bc62d28875690f2f2a3546d3672dc4af392d9c1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/kubeconform"

    (pkgshare/"examples").install Dir["fixtures/*"]
  end

  test do
    cp_r pkgshare/"examples/.", testpath

    system bin/"kubeconform", testpath/"valid.yaml"
    assert_equal 0, $CHILD_STATUS.exitstatus

    assert_match "ReplicationController bob is invalid",
      shell_output("#{bin}/kubeconform #{testpath}/invalid.yaml", 1)
  end
end
