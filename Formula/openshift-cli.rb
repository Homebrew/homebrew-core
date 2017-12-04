class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.7.0",
    :revision => "7ed6862914ef20e22280c51199be5071e354999f",
    :shallow => false

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba6d58a649fe024da00f0ae056514a8548efe3bb5100d435cde998c37ba18f22" => :high_sierra
    sha256 "eafc9557cf4d628eed8abcc911e72a4b472ea696330821664022c9d03a23b400" => :sierra
    sha256 "4806095df4f95976a7f03abf838d5b8e018fc6cbb5eae6142a130aea5ffc1440" => :el_capitan
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
