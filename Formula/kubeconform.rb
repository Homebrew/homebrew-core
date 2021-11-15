class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/v0.4.12.tar.gz"
  sha256 "3887c007061995a299bc58017e47a38dba27c561743da372e00dedec09a20875"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22cdc56e1e472411eba3441dec3a07ef340601bb775a82fd96aad40c6e701dfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aca71402ebdb7b383b9b2a0d1202681bcc816c23d0cdeaa8fe14253a15e1790f"
    sha256 cellar: :any_skip_relocation, monterey:       "2fbee45972642dcb803874a2186c9d7e8352551870b3b840246b7d95bef34998"
    sha256 cellar: :any_skip_relocation, big_sur:        "59896d6b0a79a9214e780493a7178e3a2fd376206d079d746c8601a1c39c7572"
    sha256 cellar: :any_skip_relocation, catalina:       "057e364e1e8f55490f97960fbd4f9a155de3198730c91cb24f325fa554bce3bb"
    sha256 cellar: :any_skip_relocation, mojave:         "5342902c7d6a76596cb9fa432dc545e79f8a6397c49313df5acf891c03e7602a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae4a06a6f2e2ae77140ba4a99a313ef8459e7441f94a7e7aa7ff78ab586fd763"
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
