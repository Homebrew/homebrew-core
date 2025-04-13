class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_23/aspectj-1.9.23.jar"
  sha256 "3d7aa5451d914a48507617aa23b9da00eb6085c475f02f9aba007d4002925ea2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f16cd45a206bf4a062f1e3f607a4ae5a3080fd96c3a428e279715ac9fb504a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4838a659d617af43091402334cfd0e1f1183efee9c90cc4e91f69d993b41e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8742821d35e1751c011f1101ee71e92fb651d1a757469e6e0bed65eb4aaba93e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbf6c1c609aa1c15f3e9b81011d2eecc880ff0142efc1203ee321edfea150a2b"
    sha256 cellar: :any_skip_relocation, ventura:       "197198fd436e667e64609b24f2f24eb5ac69fc2a73e78a905c18ff316d2e6ba9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "314a35397e3a764ca39a6a59d248d208fa5cdf704157934fc1332d735ceb2a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124f217589a14c449f55ba92cec515d7e0dc8bac0bfce87e9bf541a9ba56ee02"
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
