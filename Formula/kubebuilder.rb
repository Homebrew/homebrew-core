class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.2.0",
      revision: "b7a730c84495122a14a0faff95e9e9615fffbfc5"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4dad1daa9263ce2173869c13261c0ec572538bd26527e442fc88f0480fba8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18896f341179475b31589656f00c0bd6e5fe5cee86d83a8e74b8cfecbf999280"
    sha256 cellar: :any_skip_relocation, monterey:       "33b6ffe15f1b2ac1c0d64a3a8137fd118f5d02e8e92167ec2021a7669490e6d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c42883ef1ce3413ff25efcb9e36c271231bfc6b5bbb396a48e16391f4d8841e7"
    sha256 cellar: :any_skip_relocation, catalina:       "30d47238b140ac3df8761f2fedc1bb9c6a2460a2734f4eaff4b1c5bef1e1b81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782dce15eb8760239abada37e34632610dbaaf66519b89b65b4433cecc770e72"
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
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd"

    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "bash")
    (bash_completion/"kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "zsh")
    (zsh_completion/"_kubebuilder").write output
    output = Utils.safe_popen_read(bin/"kubebuilder", "completion", "fish")
    (fish_completion/"kubebuilder.fish").write output
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
