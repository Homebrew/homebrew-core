class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "https://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.3.3/jsonschema2pojo-1.3.3.tar.gz"
  sha256 "877924359f7f3faf4a95d95df1d9fd074ede64c0f982fa86408299e9442775c4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/jsonschema2pojo[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e54288130be9a5f59b961f8627cdecaf731da193d85ffe45425cb032fd5772f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e54288130be9a5f59b961f8627cdecaf731da193d85ffe45425cb032fd5772f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e54288130be9a5f59b961f8627cdecaf731da193d85ffe45425cb032fd5772f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e54288130be9a5f59b961f8627cdecaf731da193d85ffe45425cb032fd5772f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08a6643869c2531a18902af234a5a90a40106b9928a84c1918223e6454424e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a6643869c2531a18902af234a5a90a40106b9928a84c1918223e6454424e6e"
  end

  depends_on "openjdk"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
  end

  test do
    (testpath/"src/jsonschema.json").write <<~JSON
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
    JSON
    system bin/"jsonschema2pojo", "-s", "src", "-t", testpath
    assert_path_exists testpath/"Jsonschema.java", "Failed to generate Jsonschema.java"
  end
end
