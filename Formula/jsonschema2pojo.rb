class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-0.5.0/jsonschema2pojo-0.5.0.tar.gz"
  sha256 "b3bd0b49ed010b2156182146e69e13086b55d5a61cf4a5aa66408af1fdd11250"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
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
