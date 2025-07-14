class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.10",
      revision: "61183587c03f420214aac57f81dc0ecb43e1b0d6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bab6b32f94c4a46bedfa2c980d23e6ef3c35d69c1ce69097641ae7475fa0b449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0133f79beb88011e44617d586f57991d4a1236fb29841eb49a9029e52aa1c6d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fa1c585cd112ba8b624c0dbb5d5527b21b9c8f418fced7bf4f17ef2c40e30de"
    sha256 cellar: :any_skip_relocation, sonoma:        "556385086a34a7897bce553ddc5d5c806f474014be1154906c3b95de33d6c2e1"
    sha256 cellar: :any_skip_relocation, ventura:       "ff2f4e3c0c1ed2ca9d9f8be3ca841ea9abe69f67c4da8ead62147e08bf506aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13cec0bc98f9d70ef15ebb6edb3c638e8f29f0b15c419bb1298dfe5189cafd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e6264f9df5d982d96d43492aeabc68af83bc89f2b498c11c29528f9b6cbf471"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-31
  disable! date: "2025-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

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
    assert_match stable.specs[:revision].to_s, version_output
  end
end
