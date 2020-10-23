class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.4.2.tar.gz"
  sha256 "46fc0ab6b0c057fc61572777ba9807d7d57605ec987e686d057a16ffe4488ad7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "825524ab316724946a2e17fe1f2adb09a829a35e348329dbb99ec321a4d9d830" => :catalina
    sha256 "98aea461055400e3c9b3ca92e7bc506c3829cc910116015d28145a8181326305" => :mojave
    sha256 "ee3b66b8ee6abbf81eb41df69f983d46a849bd7cd8c28173c632e3d61b4ef33d" => :high_sierra
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
