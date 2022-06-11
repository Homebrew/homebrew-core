class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  stable do
    url "https://github.com/openshift/oc.git",
        tag:      "openshift-clients-4.11.0-202204020828",
        revision: "f1f09a392fd18029f681c06c3bd0c44420684efa"
  end

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8867063efd49d665866b2c6f64ec115f4469c08f90e2949b9b0b5b89cf5ab6d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f977ed51222df9a313f867141a568c2c6ce914fc599d71f758802ab1c3f68dd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e5b18766f67d10b16b519ada978371026ee4685cbbd975f7ffe29affd3073b37"
    sha256 cellar: :any_skip_relocation, big_sur:        "e17bae8eb69b676aadc58a4b2fcc2d10491270f8a138c447bd8fdae2fee462fb"
    sha256 cellar: :any_skip_relocation, catalina:       "c6111d9e409c22734dd9bd841a80be4dd5c448f30e6928d0edc9a3cb3685c0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0663c5b9780e503ba3eec7c23e3d8dd27f2485bcbc86a84701371ae3ebf1b3f"
  end

  depends_on "coreutils" => :build
  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    args = ["cross-build-#{os}-#{arch}"]
    args << if build.stable?
      "WHAT=cmd/oc"
    else
      "WHAT=staging/src/github.com/openshift/oc/cmd/oc"
    end
    args << "SHELL=/bin/bash" if OS.linux?

    system "make", *args
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
