class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerina.io/"
  url "https://product-dist.ballerina.io/downloads/0.975.1/ballerina-platform-0.975.1.zip"
  sha256 "f942dc41b975c601a75c49fd62a9eb59aa4f2b21025cabe74f32b9c7f5b5b186"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"
    chmod 0755, "bin/composer"

    inreplace ["bin/ballerina"] do |s|
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      s.gsub! /\r?/, ""
    end

    inreplace ["bin/composer"] do |s|
      s.gsub! /^BASE_DIR=.*$/, "BASE_DIR=#{libexec}/bin"
      s.gsub! /^PRGDIR=.*$/, "PRGDIR=#{libexec}/bin"
      s.gsub! /\r?/, ""
    end

    bin.install "bin/ballerina", "bin/composer"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      function main(string... args) {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
