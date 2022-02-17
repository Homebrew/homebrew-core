class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/swan-lake-beta6/ballerina-swan-lake-beta6.zip"
  sha256 "ceb39e512ca3d9c5017452f8ee159dfa0f0160618695b4a4bd9b2b142cc1cc2d"
  license "Apache-2.0"

  livecheck do
    url "https://dist.ballerina.io/downloads/swan-lake-beta6/ballerina-swan-lake-beta6.zip"
    regex(%r{href=.*?/downloads/.*?ballerina[._-]v?(\d+(?:\.\d+)+)\.}i)
  end

  bottle do
  sha256 "ceb39e512ca3d9c5017452f8ee159dfa0f0160618695b4a4bd9b2b142cc1cc2d"
  license "Apache-2.0"
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
