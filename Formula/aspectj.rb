class Aspectj < Formula
  desc "AspectJ: aspect-oriented programming for Java"
  homepage "https://eclipse.org/aspectj/"
  url "https://www.eclipse.org/downloads/download.php?file=/tools/aspectj/aspectj-1.8.9.jar"
  sha256 "bab38539cbe6e932410a104c21e18f05b773c78001f8800993da29d718d31a1b"

  bottle :unneeded

  depends_on :java

  def install
    mkdir_p "#{libexec}/#{name}"
    system "java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
    bin.write_exec_script Dir["#{libexec}/#{name}/bin/*"]
  end

  test do
    (testpath/"Test.java").write <<-EOS.undent
      public class Test {
        public static void main (String[] args) {
          System.out.println("Brew Test");
        }
      }
    EOS
    (testpath/"TestAspect.aj").write <<-EOS.undent
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
