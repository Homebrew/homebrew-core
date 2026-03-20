class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.6",
      revision: "8b2bf66ce7018f6e13e8767624d4ce7768a8a2e5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f66ab00f7f0b975c6a58b5b95964def3957fbcef93f77a2b9655a58100943fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3984298f1f1189ae79105b5d28aee1f5b31e3d7f20b201359999c95a11470ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "442db252e388c934468890f218e9d7edcee21134d1a33ae3d28f7126bd5e8e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "775de94ca9ef7b20f180ad6422bf9b827eb1834d7f77b6566360f0b8f7d00cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2760ca0eafc3f5ce9b166b2ffe53c212b262797884c06d09a361d73d228c4959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1bf98714dde2addd27af0535aba16c00c1d2d42627988782353a9e7d0e610a9"
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
