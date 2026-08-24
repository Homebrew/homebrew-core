class JavaServiceWrapper < Formula
  desc "Simplify the deployment, launch and monitoring of Java applications"
  homepage "https://wrapper.tanukisoftware.com/"
  url "https://download.tanukisoftware.com/wrapper/3.7.1/wrapper_3.7.1_src.tar.gz"
  sha256 "f437e58386776177011e9920edbab258857b3588b47422bb3b31bf3d6cf11cd8"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://download.tanukisoftware.com/wrapper/latest"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e31cd1fe9487b2def886c952f53c0ff4b62ef1bd08e0bf6f1d2a7544aae21f15"
    sha256 cellar: :any, arm64_sequoia: "fa8da3513db7cc267507a2edc14aa02dd65b4ae76b4dbd5b124ab8f6422bca8c"
    sha256 cellar: :any, arm64_sonoma:  "4a60174f2507bbea073f825738ee6210a3e0def350aee3218eda8325c56bcfde"
    sha256 cellar: :any, sonoma:        "f699fef7beb7710a5045bb9d150ceb8c27739e7f287d42e3026aafafe69f9d61"
    sha256 cellar: :any, arm64_linux:   "bfba447a5c75f7d26170271d87910dd973357cefab7a1ed7176d6bf4952c3c61"
    sha256 cellar: :any, x86_64_linux:  "e150bc8362828fa4dfc2fb7f9782ee5d0d30bdc68f1ebc3f7b8aceb438acc033"
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
