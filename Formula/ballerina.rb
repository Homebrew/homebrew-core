class Ballerina < Formula
  desc "The flexible, powerful and beautiful programming language"
  homepage "https://ballerina.io/"
  url "https://product-dist.ballerina.io/downloads/0.990.0/ballerina-0.990.0.zip"
  sha256 "a693c5a22fef9829d10027b0f9f1a33d032cb8a5ab15d0a1079d1181f2a873be"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    inreplace ["bin/ballerina"] do |s|
      s.gsub! /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
      s.gsub! /\r?/, ""
    end

    bin.install "bin/ballerina"
    libexec.install Dir["*"]
    # Add symlinks for the Language Server
    prefix.install_symlink libexec/"bre"
    prefix.install_symlink libexec/"lib"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main(string... args) {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
