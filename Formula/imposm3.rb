class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "14045272aa0157dc5fde1cfe885fecc2703f3bf33506603f2922cdf28310ebf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fdafcbc08f1e074d72e2cb9c4b1fac78bfce27bc7a13a8bcec66ef9772500ebb"
    sha256 cellar: :any,                 arm64_big_sur:  "3de66aef5a6ac996404b8649533154c33556f89bff203e25ddd6629c5aaa5996"
    sha256 cellar: :any,                 monterey:       "a21df3f6a6b84b27a6dc765c484b77369999a8bb3491a05a58a4443f2716e0ff"
    sha256 cellar: :any,                 big_sur:        "0adc7ed5a958cc0383b156184ceb0a07c567d8826480a7e0d2de56355d74e787"
    sha256 cellar: :any,                 catalina:       "d82aea779d17f54eef2f96d032a0d4332757afbb0f490e1f8dccb98cb519b5c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a792e769a9d5319b62ae64048ec8f88bf33f9d35eef724a66b5fca1a10b4496d"
  end

  depends_on "go" => :build
  depends_on "osmium-tool" => :test
  depends_on "geos"
  depends_on "leveldb"

  def install
    ENV["CGO_LDFLAGS"] = "-L#{Formula["geos"].opt_lib} -L#{Formula["leveldb"].opt_lib}"
    ENV["CGO_CFLAGS"] = "-I#{Formula["geos"].opt_include} -I#{Formula["leveldb"].opt_include}"

    ldflags = "-X github.com/omniscale/imposm3.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"imposm"), "cmd/imposm/main.go"
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
    system "imposm", "import", "-read", testpath/"sample.osm.pbf", "-mapping", testpath/"mapping.yml",
            "-cachedir", testpath/"cache"

    assert_predicate testpath/"cache/coords/LOG", :exist?
    assert_predicate testpath/"cache/nodes/LOG", :exist?
    assert_predicate testpath/"cache/relations/LOG", :exist?
    assert_predicate testpath/"cache/ways/LOG", :exist?
  end
end
