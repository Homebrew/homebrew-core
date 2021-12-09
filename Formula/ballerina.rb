class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/1.2.22/ballerina-1.2.22.zip"
  sha256 "7ffc5dbf43fdeb16febe118dbce7aa2820c026e25d047d4e15214b0ad3edffb2"
  license "Apache-2.0"

  livecheck do
    url "https://ballerina.io/downloads/"
    regex(%r{href=.*?/downloads/.*?ballerina[._-]v?(\d+(?:\.\d+)+)\.}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e57ac1df23f5296aa7e39578bca7f64ece57f130295cd7b4463361c03c9fc7b1"
  end

  depends_on "openjdk@8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
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
