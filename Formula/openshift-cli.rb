class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.4.1",
    :revision => "3f9807ab8282e1af64128834b246c41ce50172d4"

  head "https://github.com/openshift/origin.git"

  bottle do
    sha256 "88d5f098c0c13dabb5ca0929b33490c383de133905645e12b6e33869ffa60ab5" => :sierra
    sha256 "4931aeffeb58ac57166a2ea5c72a60aeb7615b0dd8e7c2b5160db41c95a3672b" => :el_capitan
    sha256 "b24f889d037d250a2f69c4cd055f3d8eb657d31dc0578821b2fecc8620359c67" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.5.0-alpha.2",
      :revision => "e4b43ee6f35d3dd8b2cbd7e92bc8a9225fa94653"
    version "1.5.0-alpha.2"
  end

  depends_on "go" => :build
  depends_on "socat"

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/oc"
    bin.install_symlink "oc" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
  end
end
