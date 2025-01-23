class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d6b012497eff1b8faa25d125ce0becb97f68c95a68dd2c35cf65a0bf3c34b833"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6e6978e709dcf02b68670fe3989e91597ad345f4c5aa33e4ad118e433d44c918"
    sha256 cellar: :any,                 arm64_sonoma:  "688528b320a8a29762059b6396c81591bb8bccdbb0fc38401b6bdbd368f271c2"
    sha256 cellar: :any,                 arm64_ventura: "392619f76111001dae5e466bd44fe49048a07bcdd4322bd6c825bd26fd660371"
    sha256 cellar: :any,                 sonoma:        "95fa7c5fde0ca11df2bc4b6a7fd491e7202ab380b6c7baddd1f47b43506059af"
    sha256 cellar: :any,                 ventura:       "adaec3d25f4e2e91faccbeb55c8b1fe73203cbfdf3182cdc870bdf7dac04e314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da189939a9103dfca0b32d55b6a2160687c972018c01232e752f9eb89c8b142c"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-s -w -X github.com/omniscale/imposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"imposm"), "cmd/imposm/main.go"
  end

  test do
    (testpath/"sample.osm.xml").write <<~XML
      <?xml version='1.0' encoding='UTF-8'?>
      <osm version="0.6">
        <bounds minlat="51.498" minlon="7.579" maxlat="51.499" maxlon="7.58"/>
      </osm>
    XML

    (testpath/"mapping.yml").write <<~YAML
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
    YAML

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
