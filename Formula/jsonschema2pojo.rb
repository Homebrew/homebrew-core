class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.1.0/jsonschema2pojo-1.1.0.tar.gz"
  sha256 "ebb8bf7f1676b823c2c60591c08665cb3de52827bfe17b30d2dc0c5850108b90"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/jsonschema2pojo[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
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
