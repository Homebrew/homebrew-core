class Imposm3 < Formula
  desc "Imports OpenStreetMap data into PostgreSQL/PostGIS databases"
  homepage "https://imposm.org"
  url "https://github.com/omniscale/imposm3/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "ab9edc262bd79dd6ee0d5547021ecd14c9931b35abb76cdeeb7cc93433ff9e13"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2cd313b199010b43cde186d8f1983abdb93c2df9b8bdb1109d681a66cbbe944"
    sha256 cellar: :any,                 arm64_ventura:  "be4cd7a2f1035e99570547e4a9deeb372d2b585da07eea07fdb9f42b77539606"
    sha256 cellar: :any,                 arm64_monterey: "f86562e84e513ca30c7d568fc13f963c5977518b68e8ea8323acd59e77f94300"
    sha256 cellar: :any,                 sonoma:         "3d680915e3156555266ede0503e0e37f1c73b8791645b88fe271ace7e0dd32cc"
    sha256 cellar: :any,                 ventura:        "ea62335f23869e6ab6bd4ccc256a452a43b8a0e658c649006f92637feb3bd4ba"
    sha256 cellar: :any,                 monterey:       "c5702658eec7b40ce205156669b3c0f9e2b06a7182e6941baf5cc0d6c19d2f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f1ebf18396335e8a5c4d998074723af58db2bf2e67e65c45ef4ddf3853a0be"
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
