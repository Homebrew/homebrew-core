class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_20/aspectj-1.9.20.jar"
  sha256 "ceb53b265132530a18c50fac4da24ce181955b936e7035c38846a8e20949024d"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4b48e6c7142fc362f6cb890d9a1b2dd8e468455d78388efb35c1d2537e01ebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e285595ea161cd01eef9a5e62061d372378f336059429aa44c9adb99a1af1479"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e153cbbb2e89939fa212becd49caf4fa19329aa59abc45ecc096e77ca7df541f"
    sha256 cellar: :any_skip_relocation, ventura:        "4c83097a3933825d7d30d36833329f710c237bc20055639c7c5fd05f7e911e69"
    sha256 cellar: :any_skip_relocation, monterey:       "042311ae4e61d5282e9a3ab31b45acc359078df8c06c71b0b94e3aab93bddc4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6fd4646d33d5c1e69bf47c31d85641ad166e35f87de73a84249c7e11361316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b69d47a18986341f434e615bddc0d985596ae4ec622bd2d09f02d87a4f967c"
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
