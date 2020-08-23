class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.12/byteman-download-4.0.12-bin.zip"
  sha256 "7aebafd6877058a1406e725be4246bcafd8efd78fa583b7192e847cb5d6b27a5"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = { JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}", BYTEMAN_HOME: libexec }
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
