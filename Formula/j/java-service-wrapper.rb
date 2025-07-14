class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.2_20250605/wrapper_3.6.2_src.tar.gz"
  sha256 "9adec5e1786d1ca50c1e2ff300f01b54a1fa4fbe631fd7512e096f7db4a9cddd"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbab0b6ad974b3224734d45f8f8c324c50f5818edf966477b4285a0f2e13992a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcdd6d00deb470d7a8542ba65fe84a4b78222aca65f0a0137cff5a7ff3dc94af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22e80ccd9a12fcacaec00a9359ddaf7c58bc936dd0aa0042ef25eac46fd2e1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "05bf4b4b9aa43398feb1a0d8ff24d1c259c8158914044d1f78bf0441f1533973"
    sha256 cellar: :any_skip_relocation, ventura:       "8ef9ed8518305d3d2d5dd6a6ad3a78f0db279256c393f8b36cf5b6642ff41c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6225995f4c1519f54f1987c72c9388b70a9c4e003443594c42d1e188be3dcf2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f282b50f8c2c2339db931a68ce8b7148f077c754ecff2934a1d05ed76c4a94"
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
