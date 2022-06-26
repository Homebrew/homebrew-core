class JingTrang < Formula
  desc "Schema validation and conversion based on RELAX NG"
  homepage "http://www.thaiopensource.com/relaxng/"
  url "https://github.com/relaxng/jing-trang.git",
      tag:      "V20220510",
      revision: "84ec6ad578d6e0a77342baa5427851f98028bfd8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0798c6cf30a390d2146bd46c35d96af3dbcf03d5eb5e1a1e6d9f31f10b3deb82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fca3a0bc0ffc4ab5732ce8cd341403ca904fff610e91791c0f2eb0f30c1a7ace"
    sha256 cellar: :any_skip_relocation, monterey:       "9a078db017574202859c27cc406c0df361e159741644dd30cde76ab20a8f6fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4709d7a43737f8d4a4d7fe0f84709cbb5c19c2039e91fa6c5e3c80764ab048c0"
    sha256 cellar: :any_skip_relocation, catalina:       "18a6ac93c958995f3237d2832f82427ac06fbbedf8087fbe175985b9c2473471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15410c690d443fdd6fe9f76557d7d847c93ae419e38546d2e7fb8cb52abb465d"
  end

  depends_on "ant" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "./ant", "ant-jar"
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
