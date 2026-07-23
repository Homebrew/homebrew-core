class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.10",
      revision: "bd6c4ad159ac77a879838b8f14f23a49bf97de5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1daae3e24bc3dc1fb4be9e65204ba3403a2d7973140b77a5eaf88aaea3a65093"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cb7a0b81c7c8d2489daab2c3df595dd623ee47d533b24b24ed63a94f82cb3e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf63433ef7f2e07034e20d0edf2b3e02890be70d0030385197d3367d80724e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d54418182270ee37f0c1fd2b5eaccbe328f7ee1aa11c8431cb2f8b26b14106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1311dbf5017e2d97ef27fcf6eee2fcb01cffa854240ee6d9f6bbe4da5cd0235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd4c48ffc5d692b7b37b68e5073a00753d87818a0c79b4cb401f0370ce51a5ec"
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
