class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.10.0",
    :revision => "dd10d172758d4d02f6d2e24869234fac6c7841a7",
    :shallow => false
  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2a4d3d7c90c2212bc7af8334a8b8a1cf7d148bbcadaad11f8d9d30322fc7060" => :high_sierra
    sha256 "cbd0dba7a0bebb2ad21c8ef7314ba2979ab58ec5b782b8ebac8d12a29eab13ae" => :sierra
    sha256 "e541e2b0e243eeacf1831908a225140e7dc095189e1c10549fbc34b405f5b971" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "socat"

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    bin.install "_output/local/bin/darwin/amd64/oc"
    bin.install_symlink "oc" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oc v#{version}/, shell_output("#{bin}/oadm version")
  end
end
