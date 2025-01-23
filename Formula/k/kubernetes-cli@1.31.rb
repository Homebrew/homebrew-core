class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.5",
      revision: "af64d838aacd9173317b39cf273741816bd82377"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b0f6211ff75dbc7eba143bec7ce4127e53e1f8770aa4ec3937387038ac45592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac4bd7587d162fdb5d76757416acaa1247d5bd12ff1bf34a5d5b43cee7c13675"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7e7cc36b9d1e9be4350dfc0901016f401b3ca17ed5f2da1db0ff4f2952c6ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab5c821cde134a1a1653aa695b022990edc7871d3b3281f779572a367ca7e45"
    sha256 cellar: :any_skip_relocation, ventura:       "b24ad35b79e05694020514f1239eceedbb5ac594d1964839b70608fe9ad6a2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f3386e40ed4fe104bae736ea1fbc349c4c228baf1372eafb2d67fea3a04054"
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
