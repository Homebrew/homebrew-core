class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
      :tag      => "v4.1.0",
      :revision => "b4261e07eda19d9c42aa9d1c748c34f8cba09168",
      :shallow  => false
  revision 1
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
      # make target is changing in >v4.1; remove this if statement when next
      # bumping stable version
      if build.stable?
        system "make", "all", "WHAT=cmd/oc"
      else
        system "make", "all", "WHAT=staging/src/github.com/openshift/oc/cmd/oc"
      end

      bin.install "_output/local/bin/darwin/amd64/oc"

      prefix.install_metafiles

      bash_completion.install "contrib/completions/bash/oc"
      zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
    end
  end

  test do
    version_output = shell_output("#{bin}/oc version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      assert_match "GitVersion:\"v#{version}", version_output
      assert_match stable.instance_variable_get(:@resource)
                         .instance_variable_get(:@specs)[:revision].slice(0, 9),
                   version_output
    end
  end
end
