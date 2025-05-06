class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.0_20250416/wrapper_3.6.0_src.tar.gz"
  sha256 "6fd1fbb5e337cc85efb9e93550d9719738f13cd3f2f361250130064ff16f8e0c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eee4be4d445246fb036ac331beed8d19e7f37ce56bd75ac270284302966a30f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d34e1a99bf4898821686e4990a6bf02d33e434032dddac0646558189abbf61b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cf0bfeb97a43c657cb20ca55842f1f13d68070f7243037349c627e42ccbe60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "930dc5cf281015c96fd01eefc46535cee54845e82b8c52c4b6e6dc8f698e4cda"
    sha256 cellar: :any_skip_relocation, ventura:       "aa76c959b205c2909bd3e36692a7ff0b2cbc46c8a38dea96607e7a3725bf5aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8275da16484756416eaf418118c3cc90628fc4f573be1d94a880523bee28b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b9c17fa7f694e903651d19bbf3ee988dd140d7f98d011b478e5b89fb77982e7"
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
