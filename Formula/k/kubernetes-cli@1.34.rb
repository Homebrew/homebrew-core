class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.4",
      revision: "14507e2fb33b11d2712ccbaed0bc282c27a4a04a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf571c24c64acc422df837141734988b6c597b59bdad68e4bc1601b1a17eaef9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5ad3f3e40f8de5a8a926474d3d2d7f9c6aa9044fdcd6fb719bb2c0d1679196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f600e4b25e5999912320410579d34b4f0a12b19f4bcf3fc3b6bd24a829a03001"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e0989ac7247af14d778147b807f8deef7dbacda57ccf6d0ab9fad4e2ac52f73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f75bb29b891ec39d7096de0d3ce9cafe67f338b53845e249a393d24bade94f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe24fd3dfa018637dfb39ddf70eb4ca4996f4841eca8218e1d56f2dc272bc2b"
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
