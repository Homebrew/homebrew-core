class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d6b012497eff1b8faa25d125ce0becb97f68c95a68dd2c35cf65a0bf3c34b833"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "64f97048173142e08936aeb2994efcd41266f6cee1d4946cb44183322cd1f30e"
    sha256 cellar: :any,                 arm64_sonoma:   "0b5303c3ec7e530e54107a251fa4ef2fc9f4c2e54463c8b344b0c64fc781d905"
    sha256 cellar: :any,                 arm64_ventura:  "bca1a61350ffd184a74065eb3ccd0af7ab33819dfc263bd9498548ea80d0e7a9"
    sha256 cellar: :any,                 arm64_monterey: "8c0746261d6dbe9bf62f862f3731e963cafdff857067879339428b4973ac020f"
    sha256 cellar: :any,                 sonoma:         "5b9c3f3a7c20f993b2e2479e57a87209231ee8321e83182fc97eaf63af22caf2"
    sha256 cellar: :any,                 ventura:        "82aa12fbd85c9d6202cd4d841b78b07b615d6eba5350da7834e5cd27773b69ba"
    sha256 cellar: :any,                 monterey:       "8deb68cd3de507b9c22026244991a9e9aca79f098beb0f144d25bc95d6e7a749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1f87849ae0dca6987ee13f5b35885efd169a8eea2eb69c24db97c385ba10234"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-X github.com/omniscale/imposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"imposm"), "cmd/imposm/main.go"
  end

  test do
    (testpath/"sample.osm.xml").write <<~EOS
      <?xml version='1.0' encoding='UTF-8'?>
      <osm version="0.6">
        <bounds minlat="51.498" minlon="7.579" maxlat="51.499" maxlon="7.58"/>
      </osm>
    EOS

    (testpath/"mapping.yml").write <<~EOS
      tables:
        admin:
          columns:
          - name: osm_id
            type: id
          - name: geometry
            type: geometry
          - key: name
            name: name
            type: string
          - name: type
            type: mapping_value
          - key: admin_level
            name: admin_level
            type: integer
          mapping:
            boundary:
            - administrative
          type: polygon
    EOS

    assert_match version.to_s, shell_output("#{bin}/imposm version").chomp

    system "osmium", "cat", testpath/"sample.osm.xml", "-o", "sample.osm.pbf"
    system bin/"imposm", "import", "-read", testpath/"sample.osm.pbf", "-mapping", testpath/"mapping.yml",
            "-cachedir", testpath/"cache"

    assert_predicate testpath/"cache/coords/LOG", :exist?
    assert_predicate testpath/"cache/nodes/LOG", :exist?
    assert_predicate testpath/"cache/relations/LOG", :exist?
    assert_predicate testpath/"cache/ways/LOG", :exist?
  end
end
