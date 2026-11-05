class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_27/aspectj-1.9.27.jar"
  sha256 "903dd70ddf2ea2ac81efa29a2fbd5ed47d76af711557fc289f4664c77cbf1cab"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d70e4f59ccaafeffa77427411e24b89925c396c67dbbe9328f1c089c8e92ac8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae28a75f1f27bff6a4306655002263f8474d91065966b44665d02baf167ff8ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ae28a75f1f27bff6a4306655002263f8474d91065966b44665d02baf167ff8ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9214a3c82901e5737f168a3e0b1d351e10f2a9f21d482e6fe75d24d816b71dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a4a1f36203a12cb62fd25bfefd43be31f75f8845e73d17b3e771371be6245d68"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    mkdir_p "#{libexec}/#{name}"
    system formula_opt_bin("openjdk")/"java", "-jar", "#{name}-#{version}.jar", "-to", "#{libexec}/#{name}"
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
