class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://www.eclipse.org/downloads/download.php?r=1&file=/tools/aspectj/aspectj-1.9.6.jar"
  sha256 "afec62c03fe154adeecf9cd599ce033fff258d1d373a82511e5df54f79ab03e2"
  revision 1

  livecheck do
    url "https://www.eclipse.org/aspectj/downloads.php"
    regex(%r{Latest Stable Release.*?href=.*?/aspectj[._-]v?(\d+(?:\.\d+)+)\.jar}im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f991df8be2c1165f44a7be041d5e5912e7e90ebddd4bd890e625e43a7fedf779"
    sha256 cellar: :any_skip_relocation, big_sur:       "137f5ff348bd9eda2b2f56beb1170ed98f1c5a59f236743bb59b76c0079bd02a"
    sha256 cellar: :any_skip_relocation, catalina:      "ce121534748f64478eef6089a7702d8d18cd9aa8ff63054beb879f2ac636dc27"
    sha256 cellar: :any_skip_relocation, mojave:        "fb258111da16128383ad986b2508911e8217a894fc71b5026fc70c22ee66649d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11091cc9a73c7f9af8354b35804ded009e1b8f88df0ae09a6c9c3d55fd2d595"
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
