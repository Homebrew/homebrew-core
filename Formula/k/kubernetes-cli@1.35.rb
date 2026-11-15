class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.10",
      revision: "ae6fece6fea92ecfcccd13af7d5f2ea8cb9b33fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b560a0bddc086781f164c4263146715d1a5ac7a42174e3f23e674719fd22a63c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73ac9aa5df5844913d50cd2ed8f6d116cfca5c422dab69dfc2c38ec75d7fba01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2dc15d6c9a3a5e6b0bd235ca5cfd99e1171e7781dd483abb7f8d8a0966704bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86916662d5653fdb3103ce88befa2f647e11eb401da87d886a3fe76934becb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bd940c3fe356f945d8e2c160fa227db8576a25248647e65acf92c06422e3e628"
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
