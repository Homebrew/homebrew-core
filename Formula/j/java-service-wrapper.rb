class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://download.tanukisoftware.com/wrapper/3.7.0/wrapper_3.7.0_src.tar.gz"
  sha256 "b14bbba6e5375817b20bb9d09eb9cf8f23f699d0be560a95a7d733fba8f500a2"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://download.tanukisoftware.com/wrapper/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "03e1aa31aa3e9473edb493fc674c0d5f9c8b0ea393574c07953e4186a699b3fb"
    sha256 cellar: :any, arm64_sequoia: "188f30a785aa919efcbd8b104f63f98a57ed444eb657ad8dae5fc35a7dac774b"
    sha256 cellar: :any, arm64_sonoma:  "c308d4f9bf7e0fcb5f4a2952d9ecd9d9478343672a9bb0a7b1a0d94a0700d6fc"
    sha256 cellar: :any, sonoma:        "93a815165b051a74d8f5638791f33411bcb32396da135cb0fa3bcd2c45ad4990"
    sha256 cellar: :any, arm64_linux:   "07b6e91268a4323eb6f51abe6cec49dc90ce5019127fb4b4a79fed8782ce279d"
    sha256 cellar: :any, x86_64_linux:  "db2775ef748afbfe3a07127d352a2dcee36578ece8da988fb39c9d7a55259f29"
  end

  depends_on "ant" => :build
  depends_on "openjdk" => [:build, :test]

  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Default javac target version is 1.4, use 8 which is the minimum available on newer openjdk.
    # Build only the targets we install without test modules
    system "ant", "jar", "compile-c", "bin", "conf", "-Dbits=64", "-Djavac.target.version=8"

    libexec.install "lib", "bin", "src/bin" => "scripts"

    # Both arches now build libwrapper.dylib; provide the .jnilib name Java expects on macOS
    ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib" if OS.mac?
  end

  test do
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home

    output = shell_output("#{libexec}/bin/testwrapper status", 1)
    assert_equal "Test Wrapper Sample Application (not installed) is not running.\n", output

    (testpath/"bin").install_symlink libexec/"bin/wrapper"
    cp libexec/"scripts/App.sh.in", testpath/"bin/helloworld"
    chmod "+x", testpath/"bin/helloworld"
    inreplace testpath/"bin/helloworld" do |s|
      s.gsub! "@app.name@", "helloworld"
      s.gsub! "@app.long.name@", "Hello World"
    end

    (testpath/"conf/wrapper.conf").write <<~INI
      wrapper.java.command=#{java_home}/bin/java
      wrapper.java.mainclass=org.tanukisoftware.wrapper.WrapperSimpleApp
      wrapper.jarfile=#{libexec}/lib/wrapper.jar
      wrapper.java.classpath.1=#{libexec}/lib/wrapper.jar
      wrapper.java.classpath.2=#{testpath}
      wrapper.java.library.path.1=#{libexec}/lib
      wrapper.java.additional.auto_bits=TRUE
      wrapper.java.additional.1=-Xms128M
      wrapper.java.additional.2=-Xmx512M
      wrapper.app.parameter.1=HelloWorld
      wrapper.logfile=#{testpath}/wrapper.log
    INI

    (testpath/"HelloWorld.java").write <<~JAVA
      public class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system "#{java_home}/bin/javac", "HelloWorld.java"
    console_output = shell_output("bin/helloworld console")
    assert_match "Hello, world!", console_output
  end
end
