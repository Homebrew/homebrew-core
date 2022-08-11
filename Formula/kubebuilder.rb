class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.6.0",
      revision: "f20414648f1851ae97997f4a5f8eb4329f450f6d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ffc21c6af5a815c6f82fc388376ade4be911e815b1b59d442a06f389b1b1580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d38e8f9b89f9a369a54908f8fa21c39854d5f0d149755af3bacf8e18c72868e5"
    sha256 cellar: :any_skip_relocation, monterey:       "55adb801e3d6f96f34a04863168ea5c9ac52b9a9860ac496d12a0f49e8cd814a"
    sha256 cellar: :any_skip_relocation, big_sur:        "19fa8c514001e6d7eff86ed0faaf9852e4d52e00726627454213850688659a23"
    sha256 cellar: :any_skip_relocation, catalina:       "3871a407e8b6297008ed2ba67bd5143ae2a67e755261119d5a74ff4ed7cfa4d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dbaa889002492dc90cbad276985580f763f8910c4d3decdddf1b59211401f58"
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
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

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
