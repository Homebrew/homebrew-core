class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/oc.git",
      tag:      "openshift-clients-4.6.0-202006250705.p0",
      revision: "51011e4849252c723b520643d27d3fa164d28c61",
      shallow:  false
  version "4.6.0"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git",
      shallow: false

  livecheck do
    url :head
    regex(/^openshift-clients-(\d+(?:\.\d+)+-\S*)?.*$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bd72706773e6bb0620c90731c955d5b1f97e724493d9844210bb2fa06a1bd2d0" => :catalina
    sha256 "e565ddf932f76f4638e2fcf6ae85a76b4c528d000df4dc8f8ae35ee77c860adb" => :mojave
    sha256 "4e8426318d66ff09d71200bbef8154d0ba965c7ae67a6f23b18a94bf59d05b3f" => :high_sierra
    sha256 "3fb7f73cdb5b933e3e05b5724ac09dddef5c6d133c7474900cb8e47321f225f6" => :sierra
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
