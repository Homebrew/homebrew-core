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
    rebuild 1
    sha256 "3a9fe73987bae768f7bb93e8fb905c8d85f7a8e4bd7faed1c851999686736376" => :mojave
    sha256 "36859d6b9fcc67175e84b5f72c823e2f7963f7216a83d4f48b54c5b0f08c719b" => :high_sierra
    sha256 "f36d41feb6b8f07cd97ebe7ed8423943287ef1a3f5c21a58555ed364433c776d" => :sierra
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
