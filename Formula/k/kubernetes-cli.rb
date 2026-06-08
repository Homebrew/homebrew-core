class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.36.1",
      revision: "756939600b9a7180fc2df6550a4585b638875e67"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c103005968193b99726e3e589e378c5e1e23cd54c90600483ff1b22516928d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc632cd49c9edc5567f985ddbdab3810759135b82c137bad6696203bbaf3afee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0e41acc05133912f697f125a096c4c6a4521b13b48fd810ef109d0897e51f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8d8908623d0836480e25ff28ed5ae6dd6a44ccb72e73c25c0831dbe802e2154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf7f6ddbf342cff3c0a39e71fe678f55950fb4e62bbda078d74047eb36dd1c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f733aae3fc8ae437f887ff0290a734d27f9b4593b21a882f347253f7d439ce42"
  end

  depends_on "go" => :build

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
