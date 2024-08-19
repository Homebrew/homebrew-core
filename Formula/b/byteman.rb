class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.23/byteman-download-4.0.23-bin.zip"
  sha256 "5b6dda957ba86d1ac83713a93d54956adb171f51ace31dd7fb857400bd77765b"
  license "LGPL-2.1-or-later"
  head "https://github.com/bytemanproject/byteman.git", branch: "main"

  livecheck do
    url "https://byteman.jboss.org/downloads.html"
    regex(/href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, sonoma:         "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, ventura:        "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, monterey:       "aac8e27679828cb79920b27d0e134477c136f3a2cad9fff8e4c1676401fa5736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a8d6c3fab2ebafd41e9663e8881c9934ad850b428f467404de710997f6fdf8"
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

    system "#{Formula["openjdk"].bin}/javac", "src/main/java/BytemanHello.java"

    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end
