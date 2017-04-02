class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing."
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/3.0.8/byteman-download-3.0.8-bin.zip"
  sha256 "7bd36464211a04e08e74e8f3adb238a0c2e1828067e25d7d26b58968ec023ba8"

  devel do
    url "https://downloads.jboss.org/byteman/4.0.0-BETA3/byteman-download-4.0.0-BETA3-bin.zip"
    sha256 "51a387cd3a795fe130cf475f47bc222ddd17022ff2f6632c0530084f684355f4"
    version "4.0.0-BETA3"
  end

  bottle :unneeded
  depends_on :java => "1.6+"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = Language::Java.java_home_env("1.6+").merge(:BYTEMAN_HOME => libexec)
    Pathname.glob("#{libexec}/bin/*") do |file|
      target = bin/File.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec/"bin/#{File.basename(file)}", env)
    end
  end

  test do
    (testpath/"src/main/java/BytemanHello.java").write <<-EOS.undent
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath/"brew.btm").write <<-EOS.undent
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
    expected = <<-EOS.undent
    Entering main
    Hello, Brew!
    Exiting main
    EOS
    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_equal(expected, actual)
  end
end
