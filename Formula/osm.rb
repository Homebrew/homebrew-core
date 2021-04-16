class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm.git",
      tag:      "v0.8.2",
      revision: "9ea49cfb762ed6433960e05719974040f5534660"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3049a4d1800a0ab5183c1598ae0da23a98468e32b62e2b4c337d1ae110c51ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "93af077b3985b8462b82c8a4225581af563e171b481c97a9210a1256a5896785"
    sha256 cellar: :any_skip_relocation, catalina:      "ebbcbcd6a695ed5e6500f7d071c9038f819f4e943353444fbc3ef7685fead3db"
    sha256 cellar: :any_skip_relocation, mojave:        "7927d28b25aca7871427f83e1dc66a1868a40f41b6384a9fdea3c4f49ce5869e"
  end

  depends_on "go" => :build

  def install
    ENV["VERSION"] = "v"+version
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
    assert_match "Version: v#{version};", shell_output("#{bin}/osm version 2>&1")
  end
end
