class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.8",
      revision: "3f46d435cd795e85aeea6b1a73742edad13b5222"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83eb9fd4d42d030e361179139f2dba5ecb72ed156f433516aac8f07982bc8a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef20ea9428b30207b4f98c81c4558d31eb21f400ac84344568d9143d0cae9f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b2c85678102bd16174e077953fb6fbd062a72f8441bcce332071efa045b9c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a3674e272490c7b7f40a979597a8e1da330708d70e0211d744bdd8071a7c20"
    sha256 cellar: :any_skip_relocation, ventura:       "ff6f471be355767cf49a4c8344ccbb6efbfafab1f2236d0861b9e37582bb2ec9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe8a3ae79ba8573f0d596216ba9620633507433c7c6e7c1412861896ef31a6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4247a1ed5b17a388dbab7778fce2d417ff30b804c9c1999e8890ebac9fdbad72"
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
