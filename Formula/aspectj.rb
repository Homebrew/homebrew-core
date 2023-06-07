class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse/org.aspectj/releases/download/V1_9_19/aspectj-1.9.19.jar"
  sha256 "3ae8f2834e72bed7327cb9aaa2773ef865fd03214ac1f2332133870f3d29c743"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d78bf62281fa0f291004065055585e42f7ee2df5f6f7ec869457e48b0fc9be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8971baec3ba3318208c5d95dc416bfa39da932444b19dfdf4804ef656e733f60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2296e96ebecc4a914230d369d718d4d9c654d1cc395cdd5a10141d5196380c37"
    sha256 cellar: :any_skip_relocation, ventura:        "0f48216a20b433eb2f2b41369fc4fff9814517940cb6a440f5604a29481002f2"
    sha256 cellar: :any_skip_relocation, monterey:       "13cfc4a1b4632ec42b5025a92939eb3c9f4908bacebe6f92cfc665eaf45556c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "62b8186c7bd78b64c63f35f230c56a0f26d1909006d494a457adcad264e48f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c817855445fba97bcdd1a5cb283e43570a7aa7861b4be6b6c3175e9413f15941"
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
