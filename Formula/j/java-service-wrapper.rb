class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://downloads.sourceforge.net/project/wrapper/wrapper_src/Wrapper_3.6.4_20251218/wrapper_3.6.4_src.tar.gz"
  sha256 "fb22e05d89f0a6a12bcd5fd8d4742ab42cbfba5324e367a87810a6a67f595a12"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f02c8a22fd1aaf7fdaaa368d6157331857801e0e7bf9a37d650b1221186232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b470ea97a958934558739c40336c45903e533376b0273e51c6267fd4e9a7d953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70b5e29df4af3c8c06ab23e6b116bec094a27a5fe5f07d0c0874aaaa3cb8514"
    sha256 cellar: :any_skip_relocation, sonoma:        "191cce9ca2610ecd1e78bb8adecd93c4a0cecd7a944d45fba843e86d6ea84062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609f36514596c3655739cbe1e39fbd842c0da0fd4b8a5cdcf9be41816283ecbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91b2cc21432a561472471c185e163d99786e0e299e7933dc039656939c27ab16"
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
