class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse/org.aspectj/releases/download/V1_9_8/aspectj-1.9.8.jar"
  sha256 "aa0606b87987281aabbed6de681b12e721d8f4c1e99c1e861c6fcd98f9b55e5b"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1361fbfb94d8485d1b7055540668aa1c2d85ced2bb21150b315971170fbde3be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26c8adb901818215bcc7a0dcddcc77044767b23cd799bd4b929f9bd43ceae487"
    sha256 cellar: :any_skip_relocation, monterey:       "64d1bb06de2c1d4cea4ea6e135ed8ea118f0c51036773d7f9eb4258f10cef97b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0092b6cc3cad96383c587fc31b081d1d5ddc0356b86eaa36f8b8b573b024e369"
    sha256 cellar: :any_skip_relocation, catalina:       "16cc1e4be12b8ffc4e8fc1ffa64633cc14c15273fb7e7cbc7686d37347b484aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09df2143a3880aeeb0decf3f81db21282fedf8a7d904b6a6bf94482545a99af2"
  end

  depends_on "openjdk"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "#{Formula["openjdk"].bin}/java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
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
