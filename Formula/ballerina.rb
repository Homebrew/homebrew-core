class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/1.2.17/ballerina-1.2.17.zip"
  sha256 "7197a3c488ff22fd2bad6c5a56deedad003d9b8484b53d0861655ec35548a7b0"
  license "Apache-2.0"

  livecheck do
    url "https://ballerina.io/downloads/"
    regex(%r{href=.*?/downloads/.*?ballerina[._-]v?(\d+(?:\.\d+)+)\.}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05816252d86061d03f32058307aea28769186400907f768490a786655043b795"
  end

  depends_on arch: :x86_64 # openjdk@8 does not have ARM support
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
