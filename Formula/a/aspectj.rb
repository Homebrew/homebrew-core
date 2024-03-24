class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_22/aspectj-1.9.22.jar"
  sha256 "910b16bbfad2ed07fb15c839559f9086082f2baf5a5150f71c2874689daa85fc"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98f8a3135ab21245baec62b2413552ae05d4deb813c5914fd335cc34934cb8c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed2ca9d085a904e0705c56ed00c70ebbc5828c63207ea141f17339c1d80803bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7111ceec36dff2c878b978d5c936d1150d111ea27c2287863676ece36b16800"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c5058efbcf9e9a1f3dcd182d935c55d7e33af622cdb61aca64334ab160816cc"
    sha256 cellar: :any_skip_relocation, ventura:        "b51ff0df41636e9816921f3a9f5fb7f1489aaaa311e545b57c738a4dfc875582"
    sha256 cellar: :any_skip_relocation, monterey:       "7280d34aa3f4011b9e8c808f97fc818a405a0c01c19296e5f64da17a4f3bd973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b4471f72f918a307db2b2eedca6c5cd85c5a257d6ad893c0c9d7b768471f67"
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
