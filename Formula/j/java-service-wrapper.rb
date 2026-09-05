class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://download.tanukisoftware.com/wrapper/3.7.3/wrapper_3.7.3_src.tar.gz"
  sha256 "6e99f0ba7fcaea582ad5922a773c1b243a1dd4fe143c0fc4639e4cb18535d851"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://download.tanukisoftware.com/wrapper/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "df75eb05ed823887a661f3a2609339a20024b9389d362bf5163dbe3fff8bb1ac"
    sha256 cellar: :any, arm64_sequoia: "07ac280c30fc8c0fad446b0d09a446cfac7afb9d864393f5c9adc2e36b328730"
    sha256 cellar: :any, arm64_sonoma:  "962c928c16efd2af779ce09af168b5536c37c7af8fd629beb8c34be199dbf227"
    sha256 cellar: :any, arm64_linux:   "776e7bc61a4311cb52da862351756852b958e75b3b753a05b20b0e7717276912"
    sha256 cellar: :any, x86_64_linux:  "561e4e053959f56fbd41755155f32e690e0799bd23385a77919d79d78c9818c5"
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
