class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.6.0",
    :revision => "c4dd4cf368b6204571faacde702e624b930a5214"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e499d511419ef45620c068ee30b5f5eec3223e063a76ce164a952492c4143ff" => :sierra
    sha256 "194662f118199fec2199fbe9b9373fc9e9a34ab4cac71cbe81b36959bfca0640" => :el_capitan
    sha256 "8cfbfcbf88a60beaa006736868e96d80f46b864db03a4d6fe90909109a021d9c" => :yosemite
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
