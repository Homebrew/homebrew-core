class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerinalang.org"
  url "https://ballerinalang.org/downloads/ballerina-tools/ballerina-tools-0.964.0.zip"
  sha256 "0ea872b63807e7e59105a353e9f7b571d8321526e3defe6a1773dc44fb6c0c7c"

  revision 1
  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/ballerina.bat"
    rm "bin/composer.bat"

    chmod 0755, "bin/ballerina"
    chmod 0755, "bin/composer"

    inreplace ["bin/ballerina"] do |s|
      # Translate ballerina script
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      # dos to unix (bug fix for version 2.3.11)
      s.gsub! /\r?/, ""
    end

    inreplace ["bin/composer"] do |s|
      # Translate composer script
      s.gsub! /^BASE_DIR=.*$/, "BASE_DIR=#{libexec}/bin"
      s.gsub! /^PRGDIR=.*$/, "PRGDIR=#{libexec}/bin"
      # dos to unix (bug fix for version 2.3.11)
      s.gsub! /\r?/, ""
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/ballerina"
    bin.install_symlink libexec/"bin/composer"
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina.io;
      function main (string[] args) {
        io:println("Hello, World!");
      }
    EOS
    system libexec/"bin/ballerina", "run", testpath/"helloWorld.bal"
  end
end
