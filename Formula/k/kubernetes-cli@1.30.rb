class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.13",
      revision: "50af91c466658b6a33d123fae8a487db1630971c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "449a3876eac5b7508ae83162e78df0cc0ab7c7e849a8637beb5fa0a21b547e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b7b3e0df3acf0fb2e27f40369396f0e9b3f848dec675bfaa9af47330271992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da1188cec14b2b23fbf60944bf20b4bb6ccf286631c9b27230af67c98cd226c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b221c81f9fa3df54591ab48d787b164adf37b8e19c7144045ee3b90d83bdce2"
    sha256 cellar: :any_skip_relocation, ventura:       "f4cae26ad2e69c8999f723671fe85feb2284a3185afdd3d688ab51182e5bdef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7355e559217d879541552e3ca34fba6ff7bcc75a64fe6284d761ba65bd80e2b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8b4d29bbb01ca18b79ef79d9210ce4677dde1675fef4a83a8a887ed68a8feac"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-30
  disable! date: "2025-07-15", because: :deprecated_upstream

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
