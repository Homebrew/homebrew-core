class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.1",
      revision: "e9c9be4007d1664e68796af02b8978640d2c1b26"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac791b6b4f85b796c3d149d40eaffdba49182d9cb3c3bcc41bca1ebc0538334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa0a61dca2cb9f1f715e5857149712aaa1ea9d102e38a92f3a3551cc04ccc3c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "037e503894b98f79de995b3121b1b66ebe2b910232f16f5851db774306a2fafd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d39d7e273202ecb43e863332bb2f4abea67a0046433f6307012a4305683c59e"
    sha256 cellar: :any_skip_relocation, ventura:       "831f826dcb0548db72a43f76860eb91b6e08ff2a75115cfa9ed0df39346251f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be01c6761621e0729a8c092c36e7e478cc5f4e7c7b98d0b704b93b43868734f"
  end

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
