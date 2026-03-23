class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_25_1/aspectj-1.9.25.1.jar"
  sha256 "c1209b5b0f561422b2a906e5af765954231b8530ee0c5d91c6267cc34f6f9034"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c09914feef8da7857dfb8c9be43e7f50c46ca782d7bdb590a1126e95243b91c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23cd98455d550e53b70e559b2ca3e43bed5d7bff0d9567155e56576d148ef549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d62738ef87457eec9bc3476fefa11e7960cf19bf58d6708cda9cfcc5d293a12"
    sha256 cellar: :any_skip_relocation, sonoma:        "c929a1ab5004dd2627c2735a2074a263be0e6f85b28b2484ff210faee7429e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "839fa3722ae5f6fce7105e0920dc3438b491a18bdf61759e4d2ec6e508727f2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94eac9e44a68ca55a717ba53ac02745d962d4d5c9d88cca780988bbefb55610d"
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
