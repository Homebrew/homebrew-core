class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.9.0",
      revision: "26f605e889b2215120f73ea42b081efac99f5162"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171b33ef310797f5dbf60df8f29889d21aad8f424d8e192baad9a1d2c43b63fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68354c935b40113c2256708993db3ead763d3a1edd45d3190c4514aea220aec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69731f736bda318e59c1a02ca8427bd931924e10af7ac00ddf53d203109151f2"
    sha256 cellar: :any_skip_relocation, ventura:        "08d8b57f99e72e49e0ab889ee1402c60ae14cf86bd9f6b5e2773d41e93d9a155"
    sha256 cellar: :any_skip_relocation, monterey:       "9680e3b12de2bc2c9ddc270b7b996b56d8e8451ba5c255f0a8c8c99135f1c22f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a344d07b3a0b9a8cd84782bb1ca8b4abb5a5e73630af158935c021e11e013f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c902c0e6f4cb8cd0494c723fe69b031327bea8383e2f464feeab635cd02eadf"
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
