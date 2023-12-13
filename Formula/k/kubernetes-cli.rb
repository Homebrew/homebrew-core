class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.0",
      revision: "3f7a50f38688eb332e2a1b013678c6435d539ae6"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "416f6344aaaa5770c66c2000b1470b5cb59d691fd2a8ddadfe1f0f078428be71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92fb909bc8129d7cfbdaacac401166abef7c75e9c3b16cf41d83724761b4e079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1c2b99707877eb3b318cde18b377f8f7374e8e8eb1c2f06bae4f471f668434"
    sha256 cellar: :any_skip_relocation, sonoma:         "71ca5334e7311e62ddd1156e7db393d9cc99dfb83186324d2eeb0bc6dc46d8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "11b43aaf7b1f764851e793530cef620b90d433c1370a498eae286735676a2aae"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc15fad02de24387f60bd11602138724a25336872ad33aa61fe32e8821b0c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ab8f36bb2ba04039b63e4fd8649778b43a1dec8f3819ca6b84725a093a998d7"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
