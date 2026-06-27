class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.9",
      revision: "ad7c7374b74c04d07ea041d367ecb1a526bdf758"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0830983dd70a82e4b77fe92dc544930739bbb30b592b3958b2080673dad1d30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7cf353a45c1977950b437f8209f051f356be0f9e8b5d2c9e6b64890c65ced64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee59d59b12ebe2a1c4ec8f11a8a3fe640c2bf3120c983f1928d7a99c27a78706"
    sha256 cellar: :any_skip_relocation, sonoma:        "880ec9409542921380d6c5d4655a06ced8cd21ba3112dbc2b5afb6a7a69a111c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f821893681076857c80404935662d437b1e5f338669d190c5b3d81cac1441c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b36e1458b18ac5d7fff2ed3cd3f38367809230a533b6b7c6caffbddd6da554"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

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
