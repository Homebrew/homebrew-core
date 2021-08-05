class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20181222",
      revision: "a3ec4cd650f48ec00189578f314fbe94893cd92d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a3f51890fe283b8408e95ecad3b5a6b0d9708fc73b4b6427cb333d08d8b4464"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbfaf15a1309a394ba34f78a6fd28062e56c05d0f118061031cb84a1f0cd2695"
    sha256 cellar: :any_skip_relocation, catalina:      "1448a797ce37ead9d47b398a2c96af6da95acecf60532fd9edc302a1468308a3"
    sha256 cellar: :any_skip_relocation, mojave:        "10424ca3b36b8219a58894bb23a29ce3abf67feb4a18e7f03a3daf2c328d459b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7d7c7ba57430d123a9b53e8f4f9e7427d1ab2c1fb0b37149572cd4dc5eb1ddeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "816cb02200808cafe1cf7665d701311d681b2eefe1ee0e554972e4844f77b0b1"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "./ant", "jar"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/jing.jar", "jing", java_version: "11"
    bin.write_jar_script libexec/"build/trang.jar", "trang", java_version: "11"
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
