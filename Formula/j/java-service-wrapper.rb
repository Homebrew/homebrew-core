class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.5.60_20241102/wrapper_3.5.60_src.tar.gz"
  sha256 "877896e14f375c0c881c3a50f8ee910bc6504b388fbbfe65128e79d763d08717"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1725997cab6a99f4c998501f580a426d236d99f7d3646c5169351ffdcf933a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64059aa72bfdc020859f4d165056e81853f9d5dbe96a9b81528499d26f656654"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "822db0a7e9aad7602ac1c22709e9f484f4b8853045327df1e34fd596656e6301"
    sha256 cellar: :any_skip_relocation, sonoma:        "938b420ed5bc359d28a32fe7c05747d8ef95db457a291b63a33fa4bb76f2ab0b"
    sha256 cellar: :any_skip_relocation, ventura:       "704050bab1d300b3d68c44b00b629c34f620e95c842398d25fe0a16d3fc1972d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43e5b9d8a16d0fdf20e1557ed2ab37d2d75d1c10bc2b7cc27cd3637507b3045d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d22d586f746ad25a2e53fa4b95b5a914ecc93e71aade2b8eabb1e9e1f01d65"
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
    assert_match <<~EOS, shell_output("bin/helloworld console")
      jvm 1    | WrapperManager: Initializing...
      jvm 1    | Hello, world!
      wrapper  | <-- Wrapper Stopped
    EOS
  end
end
