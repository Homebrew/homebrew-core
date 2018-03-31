class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.9.0",
    :revision => "191fece9305a76f262baacc9de72c2c8cb4d5601",
    :shallow => false

  head "https://github.com/openshift/origin.git"

  bottle do
    sha256 "4bf526a8099ad57cfc6208b45d3854f83b684f7dd7b450bf8478afb6ef5ca912" => :high_sierra
    sha256 "4f7abe45f4993f6c61e10c199d8a002091c1eb64e494421db6d533a53164f761" => :sierra
    sha256 "8e43f2b64310d9d38769ebbbc4acc5f6a0ceddc6721f7c3921641f560143dff7" => :el_capitan
  end

  depends_on "go@1.9" => :build
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
