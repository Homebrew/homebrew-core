class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.6.0-202006250705.p0",
      revision: "51011e4849252c723b520643d27d3fa164d28c61",
      shallow:  false
  version "4.6.0"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false

  livecheck do
    url :head
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+)(?:[._-]p?\d+)*$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2920518f09aa3e294bc4aa304a9c83ec1cc80792483854f590623cf1f214ad34" => :big_sur
    sha256 "94c8c7573dd37d9fc9107e5ac2f5476913c567bd164522e6216f235ad43975fe" => :catalina
    sha256 "b58b9fd99c7188d6b1c0722cd4797382cd30db6660f963c0a17ee2ecb26c0c75" => :mojave
    sha256 "f362d3ced8e3a03a53ef93c8afbda8e01efa9eda702ce411e09b0dbb55b633d3" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "heimdal" => :build
  depends_on "socat"

  def install
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
