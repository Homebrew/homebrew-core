class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.5_20260317/wrapper_3.6.5_src.tar.gz"
  sha256 "e1368eff719f7e1e358d5a3cb4749759cbdbdc455515eebf45ade646be1f82c0"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02d66dd4cb0b7c091065fe9a4ca074a9f1cde335a118fd78649ab83f2ef6b8a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e79a5972a4e23d6a78762f16f5542044a507ff6bfae7f64b82a68ee9b8913b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6706caef4cbceeb709a644463443c0d30d7648b2bf13205864a3bed6d71ccc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "78dfa3dd0a4ddfa5a47e120eb72ba8b7fb3f64d7f5fe466aecf1237d60e39eac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa2df42bef313633426f63cf7967f4871d9b18f1cf5ed5c4428b7206ba6618a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1884526297eddb52a7b9b445049fb5d58cdadb03fe6890690893a39011d011a"
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
