class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.36.3",
      revision: "0f29094e5b73085e3802ecc1298ecae13866bfe6"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73636d7c2e8f519b8a3d8c6c7aaadddc750bc909cef6eb4ba8c89255a039fabd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5a4e32b0c07cef0211c98caaa69e3ba9552d21e3a0878b9325d9e7ebe8cbbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39a8fa06816b11c722dd2562a2315fa9f3288751cb8d8cf826098d66d8c1075"
    sha256 cellar: :any_skip_relocation, sonoma:        "53cdfeadb322c3aca9ca232afdb0930fbf3d5cd52e109519c3a82c19aa9d248b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6403972673505d9639bbbfac283d6551824be2fb6a2d29fec82bd1ef1413d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c111a3b7c2eba16626216b2f084cabd4c336a0e8ad0de0c216f8362f578279ae"
  end

  depends_on "go" => :build

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
