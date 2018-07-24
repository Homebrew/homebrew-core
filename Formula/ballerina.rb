class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerina.io/"
  url "https://product-dist.ballerina.io/downloads/0.980.1/ballerina-platform-0.980.1.zip"
  sha256 "758337f808862e8e0d7a58b0eddd6bb74153f66691b334ca4066d8fe2a273eaf"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"
    chmod 0755, "bin/composer"

    inreplace ["bin/ballerina"] do |s|
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{prefix}"
      s.gsub! /\r?/, ""
    end

    inreplace ["bin/composer"] do |s|
      s.gsub! /^BASE_DIR=.*$/, "BASE_DIR=#{prefix}/bin"
      s.gsub! /^PRGDIR=.*$/, "PRGDIR=#{prefix}/bin"
      s.gsub! /\r?/, ""
    end

    prefix.install "bin/ballerina", "bin/composer"
    prefix.install Dir["*"]
    prefix.env_script_all_files(prefix/"bin", Language::Java.java_home_env("1.8"))
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
