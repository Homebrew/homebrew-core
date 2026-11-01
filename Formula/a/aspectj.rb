class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_26/aspectj-1.9.26.jar"
  sha256 "8c207931b685a5fdd28a12d6579e08ec8728f88ebe6eb95c87ed4dca5b623fd0"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e26be6ec472d8128f6ebd44bce13314d63d31766ac35088bba3ab3067799f2e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9504e2eb3c162694ab2901e36dbfdf6c35aa3b15cb729ddf2ca6d84f044ff3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc02f745d688b4d710515fe84686f99b6b849a246d9ef698fad0ecf7cd00fed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12e6eb8e20d236449f0ab64dcff679bf4b41499b260a8aa0f5c058ea1325431b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5a8e5346b10cb09395f828f4c9c74015bfd1a35b56168d25c9759f61ad17adf8"
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
