class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
      :tag      => "v3.11.0",
      :revision => "0cbc58b117403b9d9169dbafdfac59ef104bb997",
      :shallow  => false
  head "https://github.com/openshift/origin.git",
      :shallow  => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5c5799c73ddfc6f3f88b96ea9e61c76210a3c9ec8c8196c487811a25833873d1" => :mojave
    sha256 "9ac46b2e32e8802fe54f00843d7edc8d2ad70de5934fd38290e8dff46955302e" => :high_sierra
    sha256 "9a9273ba88209e9011c33571cdd06ad7fa1cee5aec66f5453b450723863cc894" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build
  depends_on "socat"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/openshift/origin"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v"

      bin.install "_output/local/bin/darwin/amd64/oc"
      bin.install_symlink "oc" => "oadm"

      bash_completion.install Dir["contrib/completions/bash/*"]
    end
  end

  test do
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oc v#{version}/, shell_output("#{bin}/oadm version")
  end
end
