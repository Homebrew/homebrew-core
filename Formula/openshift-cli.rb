class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v3.9.0",
    :revision => "191fece9305a76f262baacc9de72c2c8cb4d5601",
    :shallow => false

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "646d7b460448f6dabcc262319a87d2094d4ba907b006e4060a87437547289531" => :high_sierra
    sha256 "06bd3f794e590a769f67639a2b1da9215f8e03b84e80e75f41e0b65032376768" => :sierra
    sha256 "59173e57dadf60d0f5961200d69a31bf1786ec25a248248a6c9b5d5286c8e8f5" => :el_capitan
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
