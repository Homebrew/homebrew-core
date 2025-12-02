class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.14",
      revision: "4f359b2e16764ab5e175195ee6992dfb53b36acf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087825baacb21eea7f0ba0d335a06cbaa73d20bfd0009e2b3081a5accf173017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "987a7f47b50c4f231a6de7e4065166f0798691f5f2e2181eaba0f30f73528706"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "012e7da38f9e4c2cce90e002c22d06efee4f6852db983a791e20560e6925d5a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9606000e748fc77c6bc48e15a9adef96b758c4db52f8ee4713cdfc6767f07f7"
    sha256 cellar: :any_skip_relocation, ventura:       "9c5619fccd97cd9d7f94cd7b4fd2ddc76f62d14986c07b80b2a8b7dd1256b2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6094fad9dcfdcad7f85f0bd6cd7227fd2747616082cc4f6460ef8aaaf6264b"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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
