class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.2.1/ballerina-2201.2.1-swan-lake.zip"
  sha256 "6b4e68e7f877c74e9c7d0ad986bd756bd359dde11b6049784ca08ad2c35d0dd0"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/ballerina-platform/ballerina-lang.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "769fe6c09f9c2cfeea53cb09eb8fcdb086438dd954deddd6137012decec73e25"
  end

  depends_on "openjdk@11"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/bal run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
