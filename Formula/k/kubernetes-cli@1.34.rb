class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.7",
      revision: "66d3c15b9afd7f1aaa619156804202e52c897b84"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d0e37d9496adb88d5ea74d97cc73fd542d78f1af245d60dcf3998dd74c140cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ecafee2cb456d9804597656fe49ba7230bf9f4c5578553ca56d2255246f93a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86231038c00037a881bebe7c164f4efb56c598ac106c46a9dab18a8b2c38a4b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d16df7ab94dceae2a4e242c770477914ffea8665535f763a42d20e8b7ffe76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7de380f771e5e831153303b4dcebcaceb8bad47febf319c6e5e9de67a385b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb8e01688c74c3d76371d168bc28e32955ad0957f70beb8f5fef71d48258fc8"
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
