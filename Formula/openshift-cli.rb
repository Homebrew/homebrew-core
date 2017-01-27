class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.4.1",
    :revision => "3f9807ab8282e1af64128834b246c41ce50172d4"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f5db02df96decff2ff51a2debfc303694a2b3c5ea85af9b3fe75d57146e0bf6" => :sierra
    sha256 "93d16838b365823d84030517ed3a42471a76a3f1449396ed8f3c40eaefeafa1e" => :el_capitan
    sha256 "934957e2e652b4f21206a037bbf6c5f03a53e67326475884760590d9f2a1916a" => :yosemite
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
