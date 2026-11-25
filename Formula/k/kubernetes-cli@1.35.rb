class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.11",
      revision: "42b327bab2956b1f7dc113805ac73065e6a7866e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "36875618c2ac529bface69c09f4b9cd5f02994ba0e6a61e3de4807b651b27869"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c671cb4a71572428d57678a201a6d099c43022bc19a358bd67699deff7d78b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abcc1667133763f7f246d75583406f64341c98650d8e005540909700ce5687b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7a251e6b656bf248e8a227b8da2fecfb539d584db1b101c472df99b73e80d8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ebc853d186915c762b7764cde047a70a4e4761c0a28d4923db4458912463039f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "75f786eb15b8c021f13fc7337650e828046c32693a80c1084f2bc3dc701a5947"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

  depends_on "go" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  # Go dependencies are vendored
  deny_network_access!

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac? # needs GNU date
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
