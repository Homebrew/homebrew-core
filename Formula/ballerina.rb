class Ballerina < Formula
  desc "A Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://product-dist.ballerina.io/downloads/1.1.0/ballerina-1.1.0.zip"
  sha256 "801ca6c9d1db44156ad724a9ea10ecab97bb35c641faf3fc35afc97bb68f7855"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    bin.install "bin/ballerina"
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
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
