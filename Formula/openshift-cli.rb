class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.2.0",
    :revision => "2e62fabf9639c792410e98a9a1414937d4b786c9"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fbe3b0888581a3d1fcad4334f38c85e7b8478fb787721226ab1d8578441d4fe" => :el_capitan
    sha256 "85a74d8a6a9af7707d44a8be0cb21db1a9af393fecda04d8fde09ff49701c792" => :yosemite
    sha256 "7e542ffa5106b93e4ecde58643f7ad8e836b8aa1ae651e348fcfffad2e32fb17" => :mavericks
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/openshift", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/openshift"
    bin.install_symlink "openshift" => "oc"
    bin.install_symlink "openshift" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
    assert_match /^openshift v#{version}$/, shell_output("#{bin}/openshift version")
  end
end
