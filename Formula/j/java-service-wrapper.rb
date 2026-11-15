class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://download.tanukisoftware.com/wrapper/3.7.4/wrapper_3.7.4_src.tar.gz"
  sha256 "d8c5936fb894d27701e96a5685fdbf8cf1a3d4d61c465c3abdc944361ea23905"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  compatibility_version 1

  livecheck do
    url "https://download.tanukisoftware.com/wrapper/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e651d620cedc5a7181020b116f9934dc26573f6f73d9202dc92c85706ec9e7c"
    sha256 cellar: :any, arm64_tahoe:       "9a7a72187165750e8557fdefa324a45190d8bae5bad3a7620c53de9dad4cc0fe"
    sha256 cellar: :any, arm64_sequoia:     "a13d5d3891727ae53a31bd25211daee9010cf31384ac7d2abecb6ce8d34ee9d3"
    sha256 cellar: :any, arm64_linux:       "1f798359967269be8b81ffad2563a4ad87e7ccc1a8bc64021e3535f77b4825ba"
    sha256 cellar: :any, x86_64_linux:      "013e1e60fc8335865575ea2b25363dc30ba9cf2322bca596e8582ba6bb92dadf"
  end

  depends_on "ant" => :build
  depends_on "openjdk" => [:build, :test]

  on_linux do
    depends_on "cunit" => :build
  end

  deny_network_access!

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
