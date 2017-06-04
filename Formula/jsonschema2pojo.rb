class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-0.4.35/jsonschema2pojo-0.4.35.tar.gz"
  sha256 "e88b26bd477a7efb82634028b2a450ce08a5dd2a86515046225898f11cc39c1b"

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
