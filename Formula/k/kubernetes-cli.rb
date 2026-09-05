class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.37.0",
      revision: "f54c212e3a2f75d674b717a9b29052b20b60aefc"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d59d9b0bb76b639511954ba218a36cc56e097955ec8b74fde7d7c7457954ac76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2e9246d7ca9cab0fe14f95b748afbc92f740391ff5517f04c23424a2e6e50da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a49e9a8e57b0cc08d96eb71f767eef0328ff6c8c18338d4eb9e4aea4bc5b0e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d1c8e462f18489f32789a07ff911a8808a442d01043211961bfd7dd442b5220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c865c371b31fa5a0637281c59d8e143cbf30c445fd8c0b783c339d019ef9de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9b138e2251ca3d0fc2a3b35644fabf689d4ec552fc24e8e1d65682226622b0"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
