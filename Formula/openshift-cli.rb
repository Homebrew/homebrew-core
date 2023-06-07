class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.13.0-202304190216",
      revision: "92b1a3d0e5d092430b523f6541aa0c504b2222b3"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20a3d4e7f03160e043806ef767e7d2b5f19657a478ec57456e7ace460b1e837f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b535c22b6ef4dc0613f49eac6a0fe13d87208f8a2102ec7d2e5e17f6a1645bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82941a60de1cb6b02f35748691af4b5530a3c5469ccb5fe4bbd1bbdb13323b67"
    sha256 cellar: :any_skip_relocation, ventura:        "d0b081ff8112879d85f42516ef70b41a63fb6bb8dc6330f91dba943f40ffdd5e"
    sha256 cellar: :any_skip_relocation, monterey:       "764a6b96667c0e548e63626bbbfccff1d82cbe83f24e818a62e573ee6a76799c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c7ebce7efd0c7bf005cdec410a73df80a0fa78a91f58c9aac76e2a465bb739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cdefea95d7c9c3529c625e5a00b50214abbed58985419877a6d53a4b4f7623d"
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
