class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.6.1.tar.gz"
  sha256 "5256b0d4bc5d25a522fa8bcd956874d0c99570d9702860862a102bb103fa8381"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a38e413d78883cd135b3d71d18570ed3b10fcc1f0b38b291b0c294bbcd416553" => :big_sur
    sha256 "85fc54f1acd5b1a2bcf7344f176c5741485893d29073588986c3125f9ed64a7d" => :arm64_big_sur
    sha256 "0a207395ca9107cc1ccc2e43e2b8b3306ee224add2b42ab597bb542a00ac8bb4" => :catalina
    sha256 "f058402b5fa2a66548b7694ce4887160cd25b27f137bb6ce5ffb864c8b113f0f" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "build-osm"
    bin.install "bin/osm"
  end

  test do
    assert_match "Error: Could not list namespaces related to osm", shell_output("#{bin}/osm namespace list 2>&1", 1)
  end
end
