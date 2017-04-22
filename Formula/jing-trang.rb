class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang/archive/V20151127.tar.gz"
  sha256 "04cdf589abc5651d40f44fbc3415cb094672cb3c977770b2d9f6ea33e6d8932b"

  bottle :unneeded

  depends_on :ant => :build
  depends_on :java => "1.6"

  def install
    system "./ant", "jar"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/jing.jar", "jing"
    bin.write_jar_script libexec/"build/trang.jar", "trang"
  end

  test do
    (testpath/"test.rnc").write <<-EOS.undent
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
    (testpath/"test.xml").write <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
<response xmlns:core="http://www.bbc.co.uk/ontologies/coreconcepts/">
  <results>
    <thing id="http://www.bbc.co.uk/things/31684f19-84d6-41f6-b033-7ae08098572a#id">
      <core:preferredLabel>Technology</core:preferredLabel>
      <core:label xml:lang="en-gb">Technology</core:label>
      <core:label xml:lang="es">Tecnología</core:label>
      <core:label xml:lang="ur">ٹیکنالوجی</core:label>
      <core:disambiguationHint>News about computers, the internet, electronics etc.</core:disambiguationHint>
    </thing>
    <thing id="http://www.bbc.co.uk/things/0f469e6a-d4a6-46f2-b727-2bd039cb6b53#id">
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
