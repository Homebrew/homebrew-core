class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.7.1",
    :revision => "ab0f056b4415598756f2b1bd3b313b5dc613bb87",
    :shallow => false

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5d0436454761b6bf4e1c472b97d05f500d92e9b29669d640ea30c283d7ed842" => :high_sierra
    sha256 "c6538907e7fed63cb44d5f886db9a37fd7bdb1c6254858f8c1b4872cb57b075e" => :sierra
    sha256 "4c157753d72cd1c0aef0470325dcbc56a6e46ebe152e02ea4b35b28675490cc2" => :el_capitan
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
