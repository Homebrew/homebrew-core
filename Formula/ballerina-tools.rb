class BallerinaTools < Formula
  desc "Complete Ballerina Tools package (runtime + visual composer)"
  homepage "https://ballerinalang.org/"
  url "https://ballerinalang.org/downloads/ballerina-tools/ballerina-tools-0.963.0.zip"
  sha256 "344aee160c66a1eeda69143765f596aa906c3888eb9280f8252419b19b680175"

  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/ballerina.bat"
    rm "bin/composer.bat"
    # Install and symlink (Note: execuables already come properly chmod'ed)
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/ballerina"
    bin.install_symlink libexec/"bin/composer"
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
