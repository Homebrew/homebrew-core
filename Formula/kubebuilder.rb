class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.11.0",
      revision: "3a3d1d9573f5b8fe7252bf49cec6e67ba87c88e7"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "710ec8bb200b8f04b604d4b36b9b703c5a3292b5c566904b127f6cad4d2fe593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5615d27e73644a8c83463fe82072eef840701951f7e1991215f2dcfc66c768ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258c3bbbe41e1adf12d2f5bd63f5ee490b46f4c3b9677c288a7552d3504eb8a3"
    sha256 cellar: :any_skip_relocation, ventura:        "04bbcde6da62414749a68729be2fd34136b88c50418cdca51ab7bf617b139e01"
    sha256 cellar: :any_skip_relocation, monterey:       "5bfea4b4fb8e41cb01d22c1fe950359859d74754a556993b9e4fe8f70a4011a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4eeb35bb676bfd01d002f7d016ae2392d6e4136bbfee88f511637dfafcc8faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51f569d3d30b7285eb704806500115154eeeb4041a4ab10401bc5b60ba86247"
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
