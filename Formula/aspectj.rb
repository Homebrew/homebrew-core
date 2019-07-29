class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.org/aspectj/"
  url "https://www.eclipse.org/downloads/download.php?r=1&file=/tools/aspectj/aspectj-1.9.4.jar"
  sha256 "3a34189fd3482cf2fe76cfd7f3348e4de3ceb919ab48c4d7d3094190813c0798"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
    bin.install Dir["#{libexec}/#{name}/bin/*"]
    bin.env_script_all_files(libexec/"#{name}/bin", Language::Java.java_home_env("1.8"))
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
    assert_match /Aspect Brew Test/, output
  end
end
