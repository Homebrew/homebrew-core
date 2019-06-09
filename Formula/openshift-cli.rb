class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
      :tag      => "v4.1.0",
      :revision => "b4261e07eda19d9c42aa9d1c748c34f8cba09168",
      :shallow  => false
  head "https://github.com/openshift/origin.git",
      :shallow  => false

  bottle do
    cellar :any_skip_relocation
    sha256 "6654cc3108f415a4fd1b3731441c5e2d8da2379e5e0493442c35f79c0bee668b" => :mojave
    sha256 "95cbed6538f55a49fdb7e1d75f99db0fad366ca56bfeb8e374591ddf6f35a0a2" => :high_sierra
    sha256 "348d1a3c4c94c7670054d820e5c9114d903aec9cdcbb001ab845fa459877b15f" => :sierra
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
    assert_match /v#{version}/, shell_output("#{bin}/oc version")
    assert_match /v#{version}/, shell_output("#{bin}/oadm version")
  end
end
