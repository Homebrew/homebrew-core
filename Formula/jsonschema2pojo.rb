class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-0.4.23/jsonschema2pojo-0.4.23.tar.gz"
  sha256 "98fe0ce1f641646251b8b47a2234f153e97b604fa58fa45c3bdf7d5650c3adc3"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install %W[jsonschema2pojo-cli-#{version}.jar lib]
    bin.write_jar_script libexec/"jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
  end

  test do
    (testpath/"src/jsonschema.json").write <<-EOS.undent
    {
      "type":"object",
      "properties": {
        "foo": {
          "type": "string"
        },
        "bar": {
          "type": "integer"
        },
        "baz": {
          "type": "boolean"
        }
      }
    }
    EOS
    system bin/"jsonschema2pojo", "-s", "src", "-t", testpath
    assert File.exist?("Jsonschema.java"), "Failed to generate Jsonschema.java"
  end
end
