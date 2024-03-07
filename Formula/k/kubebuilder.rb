class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.14.0",
      revision: "11053630918ac421cb6eb6f0a3225e2a2ad49535"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "168a9dc40ec48b37f101b2816f591cedfed87b8c89a89edc743a31fcd1090755"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d803646014bab2958dfa8db954bf0acd50fb3dcae1462247d07009dd48f89cc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fe3acaf6e8227ce2a71cf52aa50da3f0540e7406cb7e834d4083320f7bc9673"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2dc00af9eb27a19329778ce34e97dd6d0bd33fb873b0650ba2b76bcc6f33a82"
    sha256 cellar: :any_skip_relocation, ventura:        "ea6fb03192306098f7a60b6b5fe8e6808d6708f83a9a35ae0a98033605179c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "ad28fcf1d3d37f425458135dee7f06fd96a5841fabaaa988da6bef7f221210f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e401f56c613da42292140eda4794347ba26969a9e4750b5cc8de4bc1f67b45"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp
    ldflags = %W[
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubebuilder", "completion")
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
