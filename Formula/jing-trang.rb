class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      :tag      => "V20181222",
      :revision => "a3ec4cd650f48ec00189578f314fbe94893cd92d"

  bottle do
    cellar :any_skip_relocation
    sha256 "041409b5ddb20a932c66d390b06fde4d25f89373f1d386b28e4e592686cc3ed9" => :mojave
    sha256 "c73af2f82d10dd5a7e11818c41ac687b52f4c6128157323e211ab499dc22eaa5" => :high_sierra
    sha256 "da34fcbed6b7c8700f3384a83224c20bb47cff05c6ff0ff2a7cdaaa3b89792c4" => :sierra
  end

  depends_on "ant" => :build
  depends_on :java => "1.8"

  def install
    system "./ant", "jar"
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"build/jing.jar", "jing"
    bin.write_jar_script libexec/"build/trang.jar", "trang"
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
