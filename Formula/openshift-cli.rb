class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.2.1",
    :revision => "5e723f67f1e36d387a8a7faa6aa8a7f40cc9ca46"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ba0e421382d5a6bd3598ad670dacd2561503c7f0ea0c437e300b87ac700556d" => :el_capitan
    sha256 "2fd372f087f7d96214105607d0c4e96f0239b680fc9300d4900c50ba0eb6cf7c" => :yosemite
    sha256 "d16d54280b939e44f304aa2d701f29f6057699a82a7ef6c12a10e23baf25d201" => :mavericks
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.3.0-alpha.3",
      :revision => "7998ae49782d89d17c78104d07a98d2aea704ae3"
    version "1.3.0-alpha.3"
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/openshift", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/openshift"
    bin.install_symlink "openshift" => "oc"
    bin.install_symlink "openshift" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
    assert_match /^openshift v#{version}$/, shell_output("#{bin}/openshift version")
  end
end
