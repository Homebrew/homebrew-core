class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.14.2",
      revision: "d7b4febe6b673709100b780b5b99151c5e26a206"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe28574ec2f007e41a8fedbf8f326c877980f1d45bddbc2473280566a4addf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef5d2b7a73d29bd0fc0a638088bea2a384d3f19a46c5f940bcb1fe61b4ad3c71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8cff22d46baf5a57df445df83f9105f21507915479a0269ff45432b1c2c333f"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe10adbc9afbb5d2c80bf6705b679df433deccf3a052879fe793798dd4256cc0"
    sha256 cellar: :any_skip_relocation, ventura:        "6b5da0d7ba552a10112d0eb92504db560d6d2e6117eb9c0224bda7e4bc6b2f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "fb0291b480981c450b8e241a41c228e5f9148ab0f9b33fc21d653cbcbd0f9b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "704be83fd9e35e58e6e0a5612489e1f5001a5e812eca7b14380ffd5554f6a6cc"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd"

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
