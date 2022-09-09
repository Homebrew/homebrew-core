class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v1.2.2",
      revision: "6815b679c1b182bace25abc16de5afb494777283"
  license "Apache-2.0"
  head "https://github.com/openservicemesh/osm.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad090b19f1829c7ba61fa6df2a3c3faed582217a30ebcc2d1b01a42688d45155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f4be6b55796cc74e2791f54db5c4e4d257ca7f5bb228304e6636a3be29ef52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "081240d809914d14a2029f6b59b1c654ea6ba7146a724e18f9fe7572f4204996"
    sha256 cellar: :any_skip_relocation, ventura:        "c2445b462a9aff302e5e41c50371a8dca02496f594a4b86e34b043ca4de6bba9"
    sha256 cellar: :any_skip_relocation, monterey:       "cde19296a33df4f21c31670ad12b28c53755dc87ca43d1091c53957494b2687b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5db277a8bceba61d7fb6cf92effe902904ae0ec97ff923aa01036eabd0a9306"
    sha256 cellar: :any_skip_relocation, catalina:       "efb0d237ceb2157a6714a032f736e05bf5536c2d05f058a8b82764a28c290a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb66494d288de885f44a36ea48429425ae1b04c15a26d113d75f24850a432c7b"
  end

  depends_on "go" => :build
  depends_on "helm" => :build

  def install
    ENV["VERSION"] = "v"+version unless build.head?
    ENV["BUILD_DATE"] = time.strftime("%Y-%m-%d-%H:%M")
    system "make", "build-osm"
    bin.install "bin/osm"

    generate_completions_from_executable(bin/"osm", "completion")
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version:\"v#{version}\"", shell_output("#{bin}/osm version 2>&1", 1)
  end
end
