class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20220510",
      revision: "84ec6ad578d6e0a77342baa5427851f98028bfd8"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dcb20d5192ca4d965c42beae8adab82fc8b919ee96a11d2d315a06e7aa214d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7b261bf84183f59e0c0b8d37c8fe8802297eaf894a5d132cf58a15b66c57ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a22bf4effa32d1b17b54a975e7b8dc7ca08b9991696fee7e9d95d649d6a021ec"
    sha256 cellar: :any_skip_relocation, ventura:        "fe895e7b7d28c66cf7853b53658c4d972756a33072d98039f306f70ea537f3d6"
    sha256 cellar: :any_skip_relocation, monterey:       "6e5d22a93244e1234b68ff9aec22c9f757def6cdfd127f00ecf9c426071f321c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c44cb54e793d544152dd0cb28564d52a731da574aa704e4197f21c04097875a1"
    sha256 cellar: :any_skip_relocation, catalina:       "7dcf958640d82be13d25eaebd84af8f1db6f151ada7c942609a58a14dedb5c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eed5e67a543cf3259aed905ee2a34be05ccc664e5744395609d1d7c2a093d35"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11"

  uses_from_macos "unzip" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "./ant", "jing-dist"
    system "./ant", "trang-dist"
    system "unzip", "-o", "-d", "build/dist", "build/dist/jing-#{version}.zip"
    system "unzip", "-o", "-d", "build/dist", "build/dist/trang-#{version}.zip"
    libexec.install Dir["build/dist/jing-#{version}"]
    libexec.install Dir["build/dist/trang-#{version}"]
    bin.write_jar_script libexec/"jing-#{version}/bin/jing.jar", "jing", java_version: "11"
    bin.write_jar_script libexec/"trang-#{version}/trang.jar", "trang", java_version: "11"
  end

  test do
    (testpath/"test.rnc").write <<~EOS
      namespace core = "http://www.bbc.co.uk/ontologies/coreconcepts/"
      start = response
      response = element response { results }
      results = element results { thing* }

      thing = element thing {
        attribute id { xsd:string } &
        element core:preferredLabel { xsd:string } &
        element core:label { xsd:string &  attribute xml:lang { xsd:language }}* &
        element core:disambiguationHint { xsd:string }? &
        element core:slug { xsd:string }?
      }
    EOS
    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <response xmlns:core="http://www.bbc.co.uk/ontologies/coreconcepts/">
        <results>
          <thing id="https://www.bbc.co.uk/things/31684f19-84d6-41f6-b033-7ae08098572a#id">
            <core:preferredLabel>Technology</core:preferredLabel>
            <core:label xml:lang="en-gb">Technology</core:label>
            <core:label xml:lang="es">Tecnología</core:label>
            <core:label xml:lang="ur">ٹیکنالوجی</core:label>
            <core:disambiguationHint>News about computers, the internet, electronics etc.</core:disambiguationHint>
          </thing>
          <thing id="https://www.bbc.co.uk/things/0f469e6a-d4a6-46f2-b727-2bd039cb6b53#id">
            <core:preferredLabel>Science</core:preferredLabel>
            <core:label xml:lang="en-gb">Science</core:label>
            <core:label xml:lang="es">Ciencia</core:label>
            <core:label xml:lang="ur">سائنس</core:label>
            <core:disambiguationHint>Systematic enterprise</core:disambiguationHint>
          </thing>
        </results>
      </response>
    EOS

    system bin/"jing", "-c", "test.rnc", "test.xml"
    system bin/"trang", "-I", "rnc", "-O", "rng", "test.rnc", "test.rng"
  end
end
