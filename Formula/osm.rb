class Osm < Formula
  desc "Open Service Mesh (OSM)"
  homepage "https://openservicemesh.io/"
  url "https://github.com/openservicemesh/osm/archive/v0.6.1.tar.gz"
  sha256 "5256b0d4bc5d25a522fa8bcd956874d0c99570d9702860862a102bb103fa8381"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ea4693e7560013d61b5173c7c10207c051926812c06f9173be36bc484ac71c6" => :big_sur
    sha256 "00e3e57986deab39a5dcdb4bdfd43694fcba09b19cda22e91b1d2729bb9805b1" => :arm64_big_sur
    sha256 "e7a7990a6378f86e7faa9f323dbf74b0125ca21939ddfa334ab149d0f97b7c6c" => :catalina
    sha256 "e6cc48d691a875b8e21833da92821de372ecbd4f6a424da66429c20f751d819c" => :mojave
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
