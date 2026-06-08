class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.26/byteman-download-4.0.26-bin.zip"
  sha256 "48375f14c7faa474b17e20666c730d0bdecf2b9b18bda4e6e9dacb0650c99479"
  license "LGPL-2.1-or-later"
  head "https://github.com/bytemanproject/byteman.git", branch: "main"

  livecheck do
    url "https://byteman.jboss.org/downloads.html"
    regex(/href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22f4e5ae52fca43d524b4cb9e71a119ed480359f78fc782216f61c1d31cefa48"
  end

  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])
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
    (testpath/"src/main/java/BytemanHello.java").write <<~JAVA
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    JAVA

    (testpath/"brew.btm").write <<~BTM
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
    BTM

    system "#{Formula["openjdk"].bin}/javac", "src/main/java/BytemanHello.java"

    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end
