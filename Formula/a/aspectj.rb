class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_22_1/aspectj-1.9.22.1.jar"
  sha256 "348c98561248197cfebcd568010cd8b037e639873842b47324659e4234b85f45"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "54aabd2f689a5d4d2ca3a2ee88a03cae442f4316af396e68a919182d321b0e8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e54988e0976a8353299cf6834d7b7a0081f0937cadef5a9d2bf901fdcb4c0cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b35032d71ef261589b7c13fd826300db39032c0b683058f4066919b9dca4db15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "425f8a5c1a68e427643c38437b0a2538e1e11a05fdba830de9c681f93e23634e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a19fa57fe4c374b7a7bed752101efa6cc443dae1a2d78e5e1602b55acc6d644"
    sha256 cellar: :any_skip_relocation, ventura:        "592d0669e3c41fa2e8438ef3cc68377a830f4856bc1fa7b1ce89c778f1424a91"
    sha256 cellar: :any_skip_relocation, monterey:       "d2eb36aff3ddc79a01510f8a8536ae9acfc5742052744e285aaf0b686250653c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0861454e156f00ad3b6a21034842531e4474506f49a1d4d01f56f773662ec118"
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
