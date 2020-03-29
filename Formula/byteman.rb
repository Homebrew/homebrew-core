class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.11/byteman-download-4.0.11-bin.zip"
  sha256 "33e2e305cf313edfce72fd00c1e8183850ca2dfb5c595ca4a57bf19e1af7166a"

  bottle :unneeded
  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = { :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}", :BYTEMAN_HOME => libexec }
    Pathname.glob("#{libexec}/bin/*") do |file|
      target = bin/File.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec/"bin/#{File.basename(file)}", env)
    end
  end

  test do
    (testpath/"src/main/java/BytemanHello.java").write <<~EOS
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath/"brew.btm").write <<~EOS
      RULE trace main entry
      CLASS BytemanHello
      METHOD main
      AT ENTRY
      IF true
      DO traceln("Entering main")
      ENDRULE

      RULE trace main exit
      CLASS BytemanHello
      METHOD main
      AT EXIT
      IF true
      DO traceln("Exiting main")
      ENDRULE
    EOS
    # Compile example
    system "javac", "src/main/java/BytemanHello.java"
    # Expected successful output when Byteman runs example
    expected = <<~EOS
      Entering main
      Hello, Brew!
      Exiting main
    EOS
    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_equal(expected, actual)
  end
end
