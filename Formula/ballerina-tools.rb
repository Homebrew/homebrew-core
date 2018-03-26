class BallerinaTools < Formula
  desc "Complete Ballerina Tools package (runtime + visual composer)"
  homepage "https://ballerinalang.org/"
  url "https://ballerinalang.org/downloads/ballerina-tools/ballerina-tools-0.964.0.zip"
  sha256 "0ea872b63807e7e59105a353e9f7b571d8321526e3defe6a1773dc44fb6c0c7c"

  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/ballerina.bat"
    rm "bin/composer.bat"

    # Translate ballerina script
    inreplace ["bin/ballerina"], /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
    # Translate composer script
    inreplace ["bin/composer"], /^(\[ \-z "\$BAL_COMPOSER_HOME" \] && BAL_COMPOSER_HOME)=.*$/, "\\1=#{libexec}"

    # Install and symlink (Note: execuables already come properly chmod'ed)
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
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
