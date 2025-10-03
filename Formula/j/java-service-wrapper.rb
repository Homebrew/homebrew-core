class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.3_20250910/wrapper_3.6.3_src.tar.gz"
  sha256 "7bc5ad89ed21a39b4a4ed548dfe92fc587aed40e6c75059a71309fb8042ff580"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a56e8b8c206ad3b9a79d5933feb05c5b8a3497ef77ed72926a583ea315396fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d60fd23e9c381ec86534f0563d792c69073d6ebb1eae0a9df50ed5ca0c93ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d63494914d3afbf4f4c0023cf2be4d026975e51bf9d43600392050b946df036b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cabff0d3012a618c17ab62be813e14720a2bb72ff5f5ef1974647a4b78db4895"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd32318a4a804a49a264f22f78f3becdcbee30bf72d93dae7f4743aeb28fe174"
    sha256 cellar: :any_skip_relocation, ventura:       "5294e8868c6c45b181e48c95e8e1a2a59ff0d0db12a37b9f013bc921714b9526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0024fb9067017b3957a331d717367f6ea88e811d840f626a7a183cf1d52017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e8ce950193a7872a87d0e98402c6f4a10712615bdb7db01f81383c2789d4fda"
  end

  depends_on "ant" => :build
  depends_on "openjdk" => [:build, :test]

  on_linux do
    depends_on "cunit" => :build
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    # Default javac target version is 1.4, use 1.8 which is the minimum available on newer openjdk
    system "ant", "-Dbits=64", "-Djavac.target.version=1.8"

    libexec.install "lib", "bin", "src/bin" => "scripts"

    if OS.mac?
      if Hardware::CPU.arm?
        ln_s "libwrapper.dylib", libexec/"lib/libwrapper.jnilib"
      else
        ln_s "libwrapper.jnilib", libexec/"lib/libwrapper.dylib"
      end
    end
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
