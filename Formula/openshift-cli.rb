class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.6.0-202006250705.p0",
      revision: "51011e4849252c723b520643d27d3fa164d28c61",
      shallow:  false
  version "4.6.0"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git"

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+)(?:[._-]p?\d+)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7d39145143c6b11463b66bb5ccfebb8b6a6f1f4ccba84de9f73fec38b60abd1"
    sha256 cellar: :any_skip_relocation, big_sur:       "2920518f09aa3e294bc4aa304a9c83ec1cc80792483854f590623cf1f214ad34"
    sha256 cellar: :any_skip_relocation, catalina:      "94c8c7573dd37d9fc9107e5ac2f5476913c567bd164522e6216f235ad43975fe"
    sha256 cellar: :any_skip_relocation, mojave:        "b58b9fd99c7188d6b1c0722cd4797382cd30db6660f963c0a17ee2ecb26c0c75"
    sha256 cellar: :any_skip_relocation, high_sierra:   "f362d3ced8e3a03a53ef93c8afbda8e01efa9eda702ce411e09b0dbb55b633d3"
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "heimdal" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    on_linux do
      # See https://github.com/golang/go/issues/26487
      ENV.O0
    end
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/openshift/oc"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      if build.stable?
        system "make", "cross-build-darwin-amd64", "WHAT=cmd/oc"
      else
        system "make", "cross-build-darwin-amd64", "WHAT=staging/src/github.com/openshift/oc/cmd/oc"
      end

      bin.install "_output/bin/darwin_amd64/oc"

      bash_completion.install "contrib/completions/bash/oc"
      zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
    end
  end

  test do
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    context_output = shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")

    assert_match "foo", context_output
  end
end
