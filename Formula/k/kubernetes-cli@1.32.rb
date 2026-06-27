class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.13",
      revision: "6172d7357c6287643350a4fc7e048f24098f2a1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1480fcc3b7de658c55b7e22009f52567c2ace6fe2b85c4d4b50596e7c69a658b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b4394e40d4cbba21b447ba8cf06cda90db26fe10281f2a4feec0f3301e7b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bea9edd150d89054e5ccda7a43f41405cdf6283c5749fc009ce5cb42477b5f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9f86c983bda7ccfc8f1885d997dfc5dbc4436fd0850d9aca45410c15758b8f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99130c4bad62f24f7ffd165136b4ed219873750ba7c49231476988394c5b0641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33891f40a74485dc422cc727fd6a64ac67942d55a8fed8c7218fb1bfc64258d0"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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
