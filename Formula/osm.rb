class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.0.0",
      revision: "26886c4f16ae5cc92ddfe4c62c87cd82f1cd965c"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35ecdd0a7ed86d6e60d30714ce6e17f2078d559dc1c5ab21c7465ab680a24c96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "722102c6b0bc60a31b4f809142b23ddb35f9425337555cb1e4bf8a7e3a63415e"
    sha256 cellar: :any_skip_relocation, monterey:       "3fff2216b51719f1d89de6d5598bada47d99f8cf12b33f2022fd29187db126f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba298b991a42baaa06746c805bad695a1b116e3c752e3d0880e7f52423833025"
    sha256 cellar: :any_skip_relocation, catalina:       "0676bb631e653e08f4ef70ccaa47da52fd3cb9b426e4545b67194643c30a6add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206f1c52d1bc05bcb021033972e78c6c32be0098ef94fc714826005da6d73408"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
