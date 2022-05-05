class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.4.1",
      revision: "d59d7882ce95ce5de10238e135ddff31d8ede026"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bba3b64b424f7b47e07978c609756ee8ae25cb5f2e3492bcc8b6f856dcbfd30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a249d581344db2b33b3ea838bb08b74959f53f2d1fbe7183ac67c881734f3f3b"
    sha256 cellar: :any_skip_relocation, monterey:       "3a772dedb6d98b688cc846979de0da43676350e252571f1345aba720730f9df2"
    sha256 cellar: :any_skip_relocation, big_sur:        "19963e55971474aaee7def88a99f0249f94f7125b83ba2592470a079d442d332"
    sha256 cellar: :any_skip_relocation, catalina:       "3a3e0372057bd2c5f3d007d6461e1bc163bf31f5c8dbd90f9a083c4bc8b01444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290240378b0502fa0d8ef39bd14c985527b227e092bd857cdb3a76af22923dc5"
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
