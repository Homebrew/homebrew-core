class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20241231",
      revision: "a6bc0041035988325dfbfe7823ef2c098fc56597"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8615c4782772326c690705fd978dd13cd97baa9b897c3269f154405869955507"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0890bae04b71b2979b5e95bcc055476ef225a24e02db05288c514c63542606fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c64de5b7fc48a47a2fea2e480330ca435a177346f7ef4465ebf21312a1387f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7b9d4dea1561b777b9fe73f26774cab635683266d5da7b1c5996a11e1604aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "073e593cac616bbae9b72dd5fbd417540b5c7019259a969965d3a0f64e567978"
    sha256 cellar: :any_skip_relocation, ventura:       "0a99746daf81cd2730cb3a5eb6a387e3f48c274cdc6b6431d37c1bc1cf1e342f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc69a11eb46ce257e3c4e390b5f7f6e925cf6f1de2b5958016dabdd96fc57811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1215b5eaf1160829b26fcb226de0a9050c40c6e29e291d6c339f7408faf900ab"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  uses_from_macos "unzip" => :build

  def install
    system "ant", "jing-dist"
    system "ant", "trang-dist"
    system "unzip", "-o", "-d", "build/dist", "build/dist/jing-#{version}.zip"
    system "unzip", "-o", "-d", "build/dist", "build/dist/trang-#{version}.zip"
    libexec.install Dir["build/dist/jing-#{version}"]
    libexec.install Dir["build/dist/trang-#{version}"]
    bin.write_jar_script libexec/"jing-#{version}/bin/jing.jar", "jing"
    bin.write_jar_script libexec/"trang-#{version}/trang.jar", "trang"
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
    (testpath/"test.xml").write <<~XML
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
    XML

    system bin/"jing", "-c", "test.rnc", "test.xml"
    system bin/"trang", "-I", "rnc", "-O", "rng", "test.rnc", "test.rng"
  end
end
