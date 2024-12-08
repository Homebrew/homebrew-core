class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.3.1",
      revision: "a9ee3909f7686902879bd666b92deec4718d92c9"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "016d9d995f10b2fe1b1db2c05b60a64eef16564809d6076084461029b8528151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "016d9d995f10b2fe1b1db2c05b60a64eef16564809d6076084461029b8528151"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "016d9d995f10b2fe1b1db2c05b60a64eef16564809d6076084461029b8528151"
    sha256 cellar: :any_skip_relocation, sonoma:        "a020a5cfe836ae743f6873aa92dee596beef375b819b28ead26227458ef6cc4d"
    sha256 cellar: :any_skip_relocation, ventura:       "a020a5cfe836ae743f6873aa92dee596beef375b819b28ead26227458ef6cc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2513a356dbea0491aa7a9fd001015b3be21eb1f23c53739a66c90a778994bcf5"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

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

    assert_match <<~EOS, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    EOS

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end
