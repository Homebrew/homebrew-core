class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.5.1",
    :revision => "7b451fc9cade386042723a2c03c2deee626b579c"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b28c439d3b3072da8375d3d5cca9600309f1bd5eb77161ce25b29c593ee78f3c" => :sierra
    sha256 "40774c0ba6b5431f5d26c3de66f360272074c7a7fd8706e4240b9d38cf1da9f5" => :el_capitan
    sha256 "7ec7b7c6122b461373c017dfbd7488048bffe95047d0d3b034a4fe0a41db7d2f" => :yosemite
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
