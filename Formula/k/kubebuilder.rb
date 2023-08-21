class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.11.1",
      revision: "1dc8ed95f7cc55fef3151f749d3d541bec3423c9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c35f4fb2f8f46aec40dc783282247aff2349c8109f1fc74fed20d0f86355b500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dab39bca016584a8d16380c2e59d0a8cab4da52cde895883ff86ecf5c62f06ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2014e98bb8b47d398afc31f13deedce27c47f7cdb8fb3c19782bca9db15bca"
    sha256 cellar: :any_skip_relocation, ventura:        "c5af317a8182c282ed4e326c640bddff97207436c58c2d815b4a597fa4a1ddfb"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf549a93a4f17ac04035ddabca6ec363a6f14b431fcdf3b748fbb6101c3f8b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccaf3ae0e957e5f461935cb5a4d6c3a5555cd0ab2f6393ed73a251a9299ca690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be7fd2565fd5544ca29f87f55fe3f3c4985d20ef409b8fea3e5680726dcf9c97"
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
