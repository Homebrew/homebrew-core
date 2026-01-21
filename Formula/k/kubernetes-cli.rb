class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.0",
      revision: "66452049f3d692768c39c797b21b793dce80314e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b66315fe9895dc7726ab2df26ddb1b73dea60ac7d9f30a373a4e58b8fe1f0df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa210ba43c66e9f54ccfb01612c460b63829491fe9b46f8c5083e2df9b8e77c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bbaa21344d23f043c72bacf6c630d33dc6e9da7479e73b874d5b059f503a2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9057f838f5c11145ec4acba4023d8eed4a7a742804f003fc855f3a574586e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca17c8cf10c9e2a5fd14f82ef037aef3cb96c4f632db3f009bff3dc854e2ed16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1f7c5ce7e6c8cedf7a7cc2b4594f9457692e5bf7e03f99b9373d7b9f6e6333"
  end

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
