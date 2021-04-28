class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.0.0",
      revision: "533874b302e9bf94cd7105831f8a543458752973"
  license "Apache-2.0"
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
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{Time.now.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd"
  end

  test do
    assert_match "KubeBuilderVersion:\"#{version}\"", shell_output("#{bin}/kubebuilder version 2>&1")
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system "#{bin}/kubebuilder", "init",
        "--plugins", "go/v3", "--project-version", "3",
        "--skip-go-version-check"
    end
  end
end
