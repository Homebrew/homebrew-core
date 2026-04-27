class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.36.0",
      revision: "ecf6decece6a6de25a57aad9ba90b6ce580f6f78"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af711eedfb402414afe782a10f8822bef686a3176a4f7cca0edf78d58586334a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b5910e89a1ef71a8ddee779dff4d40ca31d3d3ace3b5189b169757418ceff0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23e9240486c05a1671272cc5cc342c3c6034bebecb3742bb63fa7d47048c2dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68557eaef73ea6eb484b313cfa19257692df1e14bff31a2081f5d7a3bc4572c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2c379bcfb6c59a5f1fda54da3edb82c9fb5d8e01fc3ddbf9ba6697394057cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf4ce822c91a2ddd66217cace92043679e9d2873a24da652ec0485367443ec6"
  end

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
