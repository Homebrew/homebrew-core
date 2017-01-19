class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.4.0",
    :revision => "208f05369554aed88b0ba8736a865cde2fa2097b"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa16bc29805dd80a448cc6af5c9cc9b140bdd37c945dd8efab0e0170c4a17975" => :sierra
    sha256 "54c1a7542b02ceeff3fc226ac99a50164f12d9da41f8ccefdd948376b6a892a5" => :el_capitan
    sha256 "bd528eb29cfd0010060fa8c5c5f2945df9d53e53cd758a0d73a83887aeb7b8a9" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.5.0-alpha.2",
      :revision => "e4b43ee6f35d3dd8b2cbd7e92bc8a9225fa94653"
    version "1.5.0-alpha.2"
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
    assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
  end
end
