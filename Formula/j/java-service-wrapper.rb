class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.1_20250514/wrapper_3.6.1_src.tar.gz"
  sha256 "c33ea05d6bff80632d0b7edbd2e63e694deafc65dfaddfd08b4605f4da22f658"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "216727d5e12c520318201c389543c03c5bd95b88e71b4cf913fb24892bb54105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dc80b5bae66308592d533ccc343410e01c8881b827151df7348e4050cb3edb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13ec420a894efa500568e39a4caf2e26f14f07cdcaf4e9bd97c2196ab6a7036d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dbadd579880550a0844754cc268e0cd4917fadd7694534a464fa867dcd8ad8d"
    sha256 cellar: :any_skip_relocation, ventura:       "57045f6e4b0f1a153696aa693870f811a811626b87427bae6e55b23ed60cbfd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41df4f16608c9f6447efd063c415391ae0dfd2eff7d906ee5adab5dd2976b58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb5d428b2a9b22b01b0379e0e85e38ca3c825d3fdad2a7f73320128c04222cf"
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
      wrapper.java.classpath.1=#{testpath}
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
