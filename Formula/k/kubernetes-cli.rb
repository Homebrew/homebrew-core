class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.28.0",
      revision: "855e7c48de7388eb330da0f8d9d2394ee818fb8d"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6ccc44521c02779177403df925fc4495b13c0227054a9bb99e23896a0a227a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa7819c5727e8ca7e669d70ddc488a86fc82a206ec2a28ec1953a21c2e535b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d722eaf1c5dee70bf647eccaba9ed9d6ef14f343a03d0d33fea482d393598ba4"
    sha256 cellar: :any_skip_relocation, ventura:        "9162f72bd059ce246bb1e34b1f327666b9981c11abeb9fd54749a1f21c0108b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a11e7ab4e304f7f5255b9387094aacaa7187cd02b793bc000fe513140a1fa5ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "8afd638b8514bbac9fca85934c452186512013498fd11c71f25bc36931747c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3791e7dc0fe2e3cdf08c72b4c874988b1ec564e4ddb37b910d2ad69d96672633"
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
