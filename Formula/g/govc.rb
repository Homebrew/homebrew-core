class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https://github.com/vmware/govmomi/tree/master/govc"
  url "https://github.com/vmware/govmomi/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "ac002c71262979385c65aa42647dffdc3d36c67641d583c6d3fcfe15bce40891"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d8e74f271b53913f9e6b88b0799e8442632269f0d6d44087f7fd9128348ed40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "947c6a880982a8e296dc2c37811b0c892915fe00de9a507a33d0efb984ead9c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082454dbc85472f3e3b9e25e69041a361c6f73016b8c115a12523bc0b5201822"
    sha256 cellar: :any_skip_relocation, sonoma:         "73ad48b4779a0cf9acb151db27a107d446336015c48cdc59c196857caebe91a2"
    sha256 cellar: :any_skip_relocation, ventura:        "75891f08bfd667f2afe56b42548c12c6a4fc53d010a83e7c8ae3d6b8f7f9391a"
    sha256 cellar: :any_skip_relocation, monterey:       "e99215b02ec24bfca51faf2e1c1724ffecad2302214a7594e461a430fd21e4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365a40046f74783b2d6128389fef94910bde58a7ef56d52419c7f544f06a1b0f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}", "./#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}/#{name} env -u=foo")
  end
end
