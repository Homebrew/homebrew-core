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
    sha256 "e565ddf932f76f4638e2fcf6ae85a76b4c528d000df4dc8f8ae35ee77c860adb" => :mojave
    sha256 "4e8426318d66ff09d71200bbef8154d0ba965c7ae67a6f23b18a94bf59d05b3f" => :high_sierra
    sha256 "3fb7f73cdb5b933e3e05b5724ac09dddef5c6d133c7474900cb8e47321f225f6" => :sierra
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
