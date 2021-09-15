class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.1.0",
      revision: "92e0349ca7334a0a8e5e499da4fb077eb524e94a"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5995e72a7882ed0bbceb0502fa67dae7c8c341f702ff418cad10009fc3418694"
    sha256 cellar: :any_skip_relocation, big_sur:       "df42a3b0d95979ddde607db44ef7b068121144fb81a1cf3823e5d1f82c9aac4e"
    sha256 cellar: :any_skip_relocation, catalina:      "7ea09c20fe9e1f8d59976b46ccf8719d55b2da0bebdb1e9843d56febb0440152"
    sha256 cellar: :any_skip_relocation, mojave:        "4a1cd3cbbfd579bf148c1dac9939c6309c9558471ff92b9594b95caa9cf47936"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52e39983c8bbcc14fc5a321163172cdcab74fddcaeaf98b0bb64ee8122eebb09"
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
