class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.5.1",
    :revision => "7b451fc9cade386042723a2c03c2deee626b579c"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "349a5809fc1e681f722147bfa4044d3f2d3d6ff39a99b1264fe313be71c183c4" => :sierra
    sha256 "9f30956118d9a9a009d737818a70498befa62432f222865b33bca23f943a9910" => :el_capitan
    sha256 "b76d411adf0a5beabd7ea380f2013ecfb91ee6dc30f35b9cccd67265967817fc" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v3.6.0-alpha.1",
      :revision => "46942adea0aed0ff58965f846aa5d5021ce30e50"
    version "3.6.0-alpha.1"
  end

  depends_on "go" => :build
  depends_on "socat"

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
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    if version >= "3.6.0-alpha.0"
      assert_match /^oc v#{version}/, shell_output("#{bin}/oadm version")
    else
      assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
    end
  end
end
