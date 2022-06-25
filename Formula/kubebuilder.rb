class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.5.0",
      revision: "26d12ab1134964dbbc3f68877ebe9cf6314e926a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2c96e90d8cc4d3850bcb6cbad7d4a073c8b74661428647309c2faf8d4f6568f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f08d09f64f159570c1e5c7a8b3182f587cb0d2f0ec7235cce346ff2501c0dd02"
    sha256 cellar: :any_skip_relocation, monterey:       "433a6c4388a39abbd22983d3f8a59b23d4695f8f686151e19eaf49bd105ce1ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "012a16ce93c67889e0dd434b5d1fb7ac16b3038d7f603be9d1a5f615882b8821"
    sha256 cellar: :any_skip_relocation, catalina:       "2edc0f4cbabdbb5014761bded7e89548ccaa5d0714c4902629daa8a40df0c326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d4afe06eb6fec4495e2fb00fc753f1feead9a76cfb74aabb4cead6cb820608e"
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
