class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.4.1",
      revision: "d59d7882ce95ce5de10238e135ddff31d8ede026"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2836fc2f9170bce9ba3d710f8aaf30c090207949bab292ac897caeda06277ef9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1768842af2ce2da90cfdcdfb35ec2e2daac0bcac7ea6f40be2fcfba381a24290"
    sha256 cellar: :any_skip_relocation, monterey:       "9d7a00b0b28c0a0e086274628e272629847a2679823e9088828475b6f41843a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d6ab7689cbda1d8742be5f29c9d2b2b49ef781c8b63ac5f22e921799ebd708a"
    sha256 cellar: :any_skip_relocation, catalina:       "f946cc015dabdb2907cf8a46ec55f7832b0912748d56692dbc4839a89c60b859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06bc8fd9a63c4da9617b1aa2c9c4981dd3602bcc9fde4cdb77d3d56d032dd69"
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
