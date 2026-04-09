class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org/docs/imposm3/latest/"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "dc779a274a7ec7e86ffdb97c881b6410f82a6d21924d08b9ed0785d2cf266113"
  license "Apache-2.0"
  head "https://github.com/omniscale/imposm3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8541b92a75fb1fc113a02f87794315e3f8f6638950eb3629d1bd79ac31965576"
    sha256 cellar: :any,                 arm64_sequoia: "ef0edd9832c108b40a6eea993c88ce7c2716f05dbac67e18f4c45085acdef838"
    sha256 cellar: :any,                 arm64_sonoma:  "f9c1f47003a67cac4718eee990bce3a96fdce764d7003670edcc9e782da1939d"
    sha256 cellar: :any,                 arm64_ventura: "e73b325a6bff285c9dfe4cc6736703881518972216c2ac0cd01e0b147db07632"
    sha256 cellar: :any,                 sonoma:        "d665afcf5f6f08652ed1af431e1aa4d38eb0dd747b57ed3e7c6726d8cb75a175"
    sha256 cellar: :any,                 ventura:       "49aacfcbcbf3e519f8257f24a8366aca51460e96c51036a5232d5d1324e60f3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2545034b671e36df257d6adbc876eb1e0eec26c15469c0bf0d4ab20c16638285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f69476d6817e049c7177e14a69cff62546d2a436aff1334c83a34ee6c07d69"
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
