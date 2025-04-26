class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org/docs/imposm3/latest/"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "aec2a5e95929891afa5cb68cfa9f6b1bf326c949a002d36f3171ed194f99fc0a"
  license "Apache-2.0"
  head "https://github.com/omniscale/imposm3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0b981fc39b89a99f0d613371f665d06c0ef397a0d669b175e4df290a2b641e28"
    sha256 cellar: :any,                 arm64_sonoma:  "287e762f448341c9f4c4d27756ee9aca1dbf0383778197237fe2380aa2f3333b"
    sha256 cellar: :any,                 arm64_ventura: "cad098da6f178da1722aad7bda43bfc701d7b2227d41c6e29256f7b100e3ff26"
    sha256 cellar: :any,                 sonoma:        "923730f19c0d45256c9fe8f3dc19edd7fc5b7467b5bb5173ae98c44e4e256da4"
    sha256 cellar: :any,                 ventura:       "4bdf8a9074e1072f1573c175e3541bcf4098f3a6149d75c1f53bf4a6c888cfed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1e925c74b23c271906369233d1620786168149e65610c2ee5ca2376204cb80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27929945a7f1302d1bc192ec024181fca4cfec9ebb5b1eab90c4bc0e1430af9d"
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

    assert_path_exists testpath/"cache/coords/LOG"
    assert_path_exists testpath/"cache/nodes/LOG"
    assert_path_exists testpath/"cache/relations/LOG"
    assert_path_exists testpath/"cache/ways/LOG"
  end
end
