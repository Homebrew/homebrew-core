class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.8.0",
      revision: "a069bf1a12785fa210409c558ae668565296c675"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06e71d5c0072752fe9c53a1bb7352c4fb40194dc651cdec7ee32e2330c542713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd379266c94be30726f9c6cf78772d8be6e61dd410b4007dcf1aea5565c98b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd379266c94be30726f9c6cf78772d8be6e61dd410b4007dcf1aea5565c98b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd379266c94be30726f9c6cf78772d8be6e61dd410b4007dcf1aea5565c98b28"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea17d63e822369582ade70ce712fe744746b204b70e746f16d7d08a11aba8d01"
    sha256 cellar: :any_skip_relocation, ventura:       "ea17d63e822369582ade70ce712fe744746b204b70e746f16d7d08a11aba8d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c481fe0d2b851508e9e146ffc2adffd1076fb58e2a99729c6f847223d2082c60"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.io/v4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~YAML, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end
