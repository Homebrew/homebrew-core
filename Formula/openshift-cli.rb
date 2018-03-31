class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.9.0",
    :revision => "191fece9305a76f262baacc9de72c2c8cb4d5601",
    :shallow => false

  head "https://github.com/openshift/origin.git"

  bottle do
    sha256 "de77b8ae2ead7f243a373fcff16b2ff44df37b3f9e5d7b77745fbd12a7e9c981" => :high_sierra
    sha256 "84b0b92b5abcaed6c8e70923a01aba9b73d2884f66c15fdfc0504656d3acd874" => :sierra
    sha256 "f5d090b7be66a4f87248481e172c26e59e174066797fc81faa709a2f03df5749" => :el_capitan
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
