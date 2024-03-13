class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_21_2/aspectj-1.9.21.2.jar"
  sha256 "c2a42dca8a52d37cd7f862667b9619c168800aa3b8180605af75c08f3a921674"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fef55c5cc502cf7877fad2b76fb8d4a4762f8144243afd7d37499a27d12725c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37e2e01cc744d4a68ddadd89081d15dfee3cb2c09b68257fe56b4a5ab4baa9a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc582e134d62d08846e0d083556037e6d9f0c6f5519f798b0e1b2e1a2b2794d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4fd725143ac01cccc8cba869ff85c36fa33657409d9f6f7e986c33775b92aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "f42ad68a2915e3b18fda63e6fd54cee377b2c9ec9420be3f7d77db7de368d838"
    sha256 cellar: :any_skip_relocation, monterey:       "017087890296767c6deaa638ac23a16979635fa97d40d127c330cd39971ce3dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a719cdf15793cb5476763dcd7e9d5d274412ef70cfbeabbe4a4220918dc0eb4"
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
