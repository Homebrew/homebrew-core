class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v3.10.0",
      revision: "0fa57405d4a892efceec3c5a902f634277e30732"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0522d956eb078e975b5f7aa561decd7e440c299f0ad93416adce1a4a200bed6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce11e727a70a2d91e013e931ef4c14b3066cc31ae81aff1994636dabcb13d032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c7489f6f674a0af0af849ca8aa75d623e9f1e0d5980520a77bc590c65736566"
    sha256 cellar: :any_skip_relocation, ventura:        "4ffd5507d8efc437589d924195a8490157bf3ec3b270b782527acb3f4bd4fec0"
    sha256 cellar: :any_skip_relocation, monterey:       "102f512b6d7203ec0d83b0ea118527429604bc0a70925a85d45a2bc576657991"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b5959b58568ddcaee108867b214c6ca28ff8930fc1c19cbacaab4101e166dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557f964712ef420a5b873e7c25ab461ed91ea52c11145895f9a0fd2326dfa56d"
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
