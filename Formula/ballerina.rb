class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerinalang.org"
  url "https://ballerinalang.org/downloads/ballerina-runtime/ballerina-0.95.8.zip"
  sha256 "a8466a27417021afd1f4bf9669449d1786ede92660b52faff93b080531422098"

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
    system libexec/"bin/ballerina", "run", testpath/"helloWorld.bal"
  end
end
