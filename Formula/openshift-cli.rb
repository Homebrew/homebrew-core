class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.3.0",
    :revision => "d45151824821195c9d3db7e5d2da0a1c982a614c"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d20ef7c33fc7abf164220b9d750dff98b576c37c17da5783fc320dc13e4bd1f0" => :el_capitan
    sha256 "b076f18b911f07739b5d77394e511eb16df43a78eb1074f350a5c08da930889e" => :yosemite
    sha256 "561edbcedb37887ccb241c6e415a11c827e44fb99657e73ad7d30857f35fa577" => :mavericks
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
