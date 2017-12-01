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
    sha256 "c6f1e0decfe40306c6702ec133f8d7f4c3088af952dd73b15fc13472016dc0b7" => :high_sierra
    sha256 "099bc68277fe95c967e10335946a8390841a0a6063aa1faae3f117c324c7513d" => :sierra
    sha256 "e2793c5263e1edf9286cb1ddbb4ff5ad0482934875f41268e3ef06646ad6f35e" => :el_capitan
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
