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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba1ac3cb97607da7dca52fe1056b68801f37d69ce49a9f6087ef25a2060725c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f71b7163b12605d316693a1a1659475fdf4d267db5c4242bbf9cfd5601c898ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96f681bea44c8e059e016df6ceedcbaeea5643d3a9b6a1c03898a28ee2f3f585"
    sha256 cellar: :any_skip_relocation, ventura:        "978b46d713dc8f49e9b5e44de94decfb9cf27f6bde217d24de31494a80e90102"
    sha256 cellar: :any_skip_relocation, monterey:       "12f220767a0aa3c37413c81ac447b3fa7cbe739125b065b7a87fd75cb62872bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5102fc4a9bd788b0ebfc4df3fa2f4f68568be929db6bc933bd4418fe72ae80c0"
    sha256 cellar: :any_skip_relocation, catalina:       "d29f854a807e9b77c658ffdea377fcedb0ace532eae1c99c09a8e43787712e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55eb4b18cc17eead8458ec3492dc7c4e788f6346f786220ea0aa48f47b194cae"
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
