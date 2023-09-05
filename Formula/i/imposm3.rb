class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "14045272aa0157dc5fde1cfe885fecc2703f3bf33506603f2922cdf28310ebf0"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9df6c793fdb5bd2785a5059b8ac87481c0e6e2ed5b2c4b5be3518ae61e144386"
    sha256 cellar: :any,                 arm64_big_sur:  "d1677327dc941f87f5911802bb7f2f1f53421af8f3a2af0dc65570dcb0575571"
    sha256 cellar: :any,                 ventura:        "a864f7988711895b30f5d0f32b8cc21d9231e5af209683c0f6ca48a12d51416c"
    sha256 cellar: :any,                 monterey:       "9d581e63f4f788afaf861bac0f4e566ce1c859bfd4d6dbc9cc46baf98dc2a577"
    sha256 cellar: :any,                 big_sur:        "2c6b3899baa3daa767d6c8a96345081227786265a5d65610a9e5bb8394013505"
    sha256 cellar: :any,                 catalina:       "10eefdae94b1af4437ff499d3081b81268545805fe780282f7751578f14c1844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efb211d2a97588a4036f0d3817417f9c8f424ce70126492fbaed61d3373e41aa"
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
