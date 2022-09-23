class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.12.0-202208031327",
      revision: "3c85519af6c4979c02ebb1886f45b366bbccbf55"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0014adf50d782523d19caf3277f86b72a3d75aa5e98a6cc143214c6f3e8919c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a904e24d03b473663b6c47cd459e3e91f4bd78fcde7c08f8ffdd6dd7333a0fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "ebb452458353b75d29726d7650f59a0eb24edc60574e7a87269658ee958083dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "54738cd33c03203ab673f43b70202252fce2b9cd63d9be1f2d720c85addc8947"
    sha256 cellar: :any_skip_relocation, catalina:       "8cb6b4c75b9a4d73bbfabdc2d8c58c6e91fcf648aac76e3967708a82e5d3949b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7bd6d5061ac5ba80ae76957c4ce1283654c78e9fb248e067928b46d2f25870c"
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"

    bash_completion.install "contrib/completions/bash/oc"
    zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
  end

  test do
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    context_output = shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")

    assert_match "foo", context_output
  end
end
