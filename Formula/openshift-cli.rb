class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.5.0",
    :revision => "031cbe45b7da52e19f0c0fae235776b38024517f"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f5db02df96decff2ff51a2debfc303694a2b3c5ea85af9b3fe75d57146e0bf6" => :sierra
    sha256 "93d16838b365823d84030517ed3a42471a76a3f1449396ed8f3c40eaefeafa1e" => :el_capitan
    sha256 "934957e2e652b4f21206a037bbf6c5f03a53e67326475884760590d9f2a1916a" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v3.6.0-alpha.1",
      :revision => "46942adea0aed0ff58965f846aa5d5021ce30e50"
    version "3.6.0-alpha.1"
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
    if version >= "3.6.0-alpha.0"
      assert_match /^oc v#{version}/, shell_output("#{bin}/oadm version")
    else
      assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
    end
  end
end
