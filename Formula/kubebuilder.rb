class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v2.3.2",
      revision: "5da27b892ae310e875c8719d94a5a04302c597d0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "707aef884202daa9ed9b73f25eb273e50f16c66ad8804c85491c39c829a62508"
    sha256 cellar: :any_skip_relocation, big_sur:       "b499cdc4e8a9cce3aa86e4389a11df135f9e98243885e72aa68909562764c8a0"
    sha256 cellar: :any_skip_relocation, catalina:      "cce2102add561ecada291b8be0cd11a9ef0964d74a8fa986297c924328590686"
    sha256 cellar: :any_skip_relocation, mojave:        "c3a57402286dc024bbd327dc212ed5f006add1717e2452d91f03ab76ead76239"
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v2/cmd/version.buildDate=#{Time.now.iso8601}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "./cmd"
    prefix.install_metafiles
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "#{bin}/kubebuilder", "init",
        "--repo=github.com/example/example-repo", "--domain=example.com",
        "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
    end
  end
end
