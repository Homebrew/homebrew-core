class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.9",
      revision: "a87cd6906120a367bf6787420e943103a463acba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.30(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0cfad8821bf8524058d33696cf1c8a4ddb96d790d185f803b4ccfa045483a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db1d32c2474cd7a79f0042d7f25a4d4b5d0d471ac94c29278b4f7f7202346ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1803b9fb52b6ce4980d231f103fb0fb974cf82cd9bc5110cdf64ce6cf1e52e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17dc81daf072362d80b0d6984858f23750397e2fa5b18a5360722162e19144a"
    sha256 cellar: :any_skip_relocation, ventura:       "4df26dd9aeeb1042b579b547dd4f8dc572f85499b4ad2df63ad815d70633040f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40c67c38ed269cfba56410c63129013f85d23ec266e6b888d856fd4a21744eb9"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

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
