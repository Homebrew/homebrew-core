class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.0.2/jsonschema2pojo-1.0.2.tar.gz"
  sha256 "158e927558e3ae4779dc2b7cd00e2010e43465af5a5aebdb55c889ccacb4d6e3"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    (bin/"jsonschema2pojo").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/lib/jsonschema2pojo-cli-#{version}.jar" "$@"
    EOS
  end

  test do
    (testpath/"src/jsonschema.json").write <<~EOS
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
    assert_predicate testpath/"Jsonschema.java", :exist?, "Failed to generate Jsonschema.java"
  end
end
