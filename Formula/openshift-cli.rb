class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.3.0",
    :revision => "d45151824821195c9d3db7e5d2da0a1c982a614c"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90196f8d3af1f656f4852cf77cb87ec7e4c875756f46d286929b7f92c54b276d" => :sierra
    sha256 "f3e1eeac3db019c145c0b3533459914dd5b51095e8e330e94cc0d1cc0911686d" => :el_capitan
    sha256 "670967f582dbdc66d21b5fff6178c9fbe0f56a14544348a3a40ee72e77950d8a" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.4.0-alpha.0",
      :revision => "67479ffd447d68d20e556746d56eb80458b9294c"
    version "1.4.0-alpha.0"

    depends_on "socat"
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/oc"
    bin.install_symlink "oc" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
  end
end
