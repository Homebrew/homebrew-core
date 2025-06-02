class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_24/aspectj-1.9.24.jar"
  sha256 "a7e50eb6e3fc84dca67ef98bfd23e0f7d62b854ee6e460ee76d2c84aa2f94d64"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("_", ".")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4152ef5f5cc3d500f07eb15b473664514ec526236023f09f264c611116b5c0a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d67b498eb0695a39fe6433b26b1596133b6ea96b7447b0c87faaf52d01449d7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e3655d41292a397894c42224ebad82a8f8b148c37412df585101d990c33ef11"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e7e80a023967b28d4e59ac2e6d0759d0694c172caada43e71433bcec1818b47"
    sha256 cellar: :any_skip_relocation, ventura:       "cb48488f8ba0912d61e0898bfcb8bc35e1db6de0a5305c8b8fbcaf37fad36445"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28007c75d40b247529b233d673cc9d77b267b3df1941d907610f21d3a42cf021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4df2c89c71fc6de62f39915e5e38b5b2d60019bf6c249475ee09e3f84475681d"
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
    (testpath/"Test.java").write <<~JAVA
      public class Test {
        public static void main (String[] args) {
          System.out.println("Brew Test");
        }
      }
    JAVA
    (testpath/"TestAspect.aj").write <<~JAVA
      public aspect TestAspect {
        private pointcut mainMethod () :
          execution(public static void main(String[]));

          before () : mainMethod() {
            System.out.print("Aspect ");
          }
      }
    JAVA
    ENV["CLASSPATH"] = "#{libexec}/#{name}/lib/aspectjrt.jar:test.jar:testaspect.jar"
    system bin/"ajc", "-outjar", "test.jar", "Test.java"
    system bin/"ajc", "-outjar", "testaspect.jar", "-outxml", "TestAspect.aj"
    output = shell_output("#{bin}/aj Test")
    assert_match "Aspect Brew Test", output
  end
end
