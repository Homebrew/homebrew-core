class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.12",
      revision: "26c89157669bdc7e3657302bc1abde758507095b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20cab07242b18a54bab5f265f58edd3ad87cc0f0587b80e701b0c6528f001c3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bf1fd06054ce91d6cfbbc794646e9f89eca432f370d4a607f285b944d5df489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e5d97dc7e99f6394220d3eebc7a023ad0b7b80b0439fa808088f8f3df4163d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a14ef96376d0a0433cf8613756e48e10023495b18272bd0cd18ba94131ccf35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "630053bd7a06fff3ab8630eba89c02fb61570e8d6b06731d32af2855d7466129"
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
