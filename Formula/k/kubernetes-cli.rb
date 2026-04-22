class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.4",
      revision: "7b8c6cf0edd376b3d7c2f255142977c7f93db258"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2298163a4dd8c398c3a167bc3730e51255dcb1f593677dc966baf6f0e6c4937c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db2b22a66b557435acddc139ebb7b23a693eab81148d52f69b2452dd01029dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "727e92d4aa119d1e50b650541176944523bccdb9f6e5137f4ee3a02d2a281221"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7c5fd0c6ca2c0ed23ef0e1973af5fd54792501f98760c9a5b77a315b067d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9443c60faa0b2a85778066165172ba7380f35362b1d1bdaef10e6030e1a19cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa476287dde9ff929e43aa7afa66ab9f1dfdce83cafa09e0ba359d457090ba9"
  end

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

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
