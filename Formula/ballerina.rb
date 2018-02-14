class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerinalang.org/"
  url "https://ballerinalang.org/downloads/ballerina-runtime/ballerina-0.96.0.zip"
  sha256 "7bbaecbbce0f2132854104a7975dec7e9019ed699536dedca3499d42f908cc87"

  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/ballerina.bat"

    chmod 0755, "bin/ballerina"

    inreplace ["bin/ballerina"] do |s|
      # Translate ballerina script
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      # dos to unix (bug fix for version 2.3.11)
      s.gsub! /\r?/, ""
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/ballerina"
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      function main (string[] args) {
        println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
