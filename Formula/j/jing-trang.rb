class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20241231",
      revision: "a6bc0041035988325dfbfe7823ef2c098fc56597"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd185ecd711ae39122b5a5c2b7d1ac25fb655d24db51a20ddbfe3fe081bc0be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59e3c55b275f245636396619acf1d1d99e5673aca25f21d546bfc151cb370ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "908bcd6e6f9ed7d3a00030052aadef34a4fd796fde206f54b61299c26a320a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7742f4501958222de06977c2be07e64fdcf2197400aa3043136bf6e370bd1e"
    sha256 cellar: :any_skip_relocation, ventura:       "384ffca335b8ed354aabcc431f161a8da3f375116d1e20b56de0f080f3182166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a3f1c8df1a2607c3640ea20c71d26027067f9ec7c8fe5878d627d222dd26a5"
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
