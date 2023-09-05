class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_20_1/aspectj-1.9.20.1.jar"
  sha256 "9f37838b559d9c86790c5c69645481ff873a16057bc114323b5bb14656936416"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1265454259b88ce08c2bd0a5923b6e0740c578300a2749144ccb513360744c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "075b826056529da2c82c8a51f9f0dfe5696b5a1eb5ec5b56bacc39276d13aca7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b47d0da2aad2b92fdfbb58e9563e1629888e5e6e3d4a95f4d028edf4441697ca"
    sha256 cellar: :any_skip_relocation, ventura:        "7122a63ee0a47f9fa04443f4b83ce2128afa1ebf879650b153840743d1b02498"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcb50e4ccfc1ab291d4960c501f012f4d03c0c615732035e3751d72d561d3bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c70934a17e83ff66a81a23281052f97082b4e2fc4fcd25af08eb934a953e886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a12fe5b79a589997a056513812a89277f9ff446cc5f51de1056e331f62be3e"
  end

  depends_on "openjdk"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "#{Formula["openjdk"].bin}/java", "-jar", "#{name}-#{version}.jar", "-to", "#{libexec}/#{name}"
    bin.install Dir["#{libexec}/#{name}/bin/*"]
    bin.env_script_all_files libexec/"#{name}/bin", Language::Java.overridable_java_home_env
    chmod 0555, Dir["#{libexec}/#{name}/bin/*"] # avoid 0777
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main (String[] args) {
          System.out.println("Brew Test");
        }
      }
    EOS
    (testpath/"TestAspect.aj").write <<~EOS
      public aspect TestAspect {
        private pointcut mainMethod () :
          execution(public static void main(String[]));

          before () : mainMethod() {
            System.out.print("Aspect ");
          }
      }
    EOS
    ENV["CLASSPATH"] = "#{libexec}/#{name}/lib/aspectjrt.jar:test.jar:testaspect.jar"
    system bin/"ajc", "-outjar", "test.jar", "Test.java"
    system bin/"ajc", "-outjar", "testaspect.jar", "-outxml", "TestAspect.aj"
    output = shell_output("#{bin}/aj Test")
    assert_match "Aspect Brew Test", output
  end
end
