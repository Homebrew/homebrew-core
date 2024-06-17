class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.2",
      revision: "39683505b630ff2121012f3c5b16215a1449d5ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb883c00bc96fbac7a08f5c3c9f9914fc099c136a8b7336ac9cbc5251a5afb95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61b8492ac3639b6e33b92a23c63a6baa2e06cb14216ea6169842d02a9b15aee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aabbbfd1d117e330cb36e1118603f12e9ebcedddcc547f400e069a8f9d805035"
    sha256 cellar: :any_skip_relocation, sonoma:         "8510fedebdd980a7ddb305e90c745db23cb2d501ed798802fb520775e5bc3778"
    sha256 cellar: :any_skip_relocation, ventura:        "f4192cff11aa74bebbe8b27e032545602a1e13b0f32a74bc3272e67273773a63"
    sha256 cellar: :any_skip_relocation, monterey:       "39856bb14b195c990ba84f1c7b4ca1a603d03f5ac3eec119a8043b42224bad39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e14a3ad9d310d78bd27840026ce7a0256bdcd3dff6c4c4bec306fdc7220ab964"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
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
