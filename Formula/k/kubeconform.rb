class Kubeconform < Formula
  desc "FAST Kubernetes manifests validator, with support for Custom Resources!"
  homepage "https://github.com/yannh/kubeconform"
  url "https://github.com/yannh/kubeconform/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c345de9c3207f2d24628c64fe3cb9bed55c4248b12c181efe81ee907d6c994f2"
  license "Apache-2.0"
  head "https://github.com/yannh/kubeconform.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b5965b37da2b084932eb88327d3174b542a2c59de2f8035b30cced7ce8be3ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5965b37da2b084932eb88327d3174b542a2c59de2f8035b30cced7ce8be3ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5965b37da2b084932eb88327d3174b542a2c59de2f8035b30cced7ce8be3ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f820ebe12cc4ab5d467f99220467173700fd32e8ebcbd2f11456fed25d861aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebedb63f8734f9a6bc8feca5e651aa2f346af7aec39acb7bfad92ae118e9b0e6"
    sha256 cellar: :any,                 x86_64_linux:  "65bc4ae01f3563490655e98c097d45f005f9b69dc8ba2bdae36b7ff6bb5fee19"
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
