class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_21/aspectj-1.9.21.jar"
  sha256 "fdc75f12952b2b7f6cb15b9a942296746869ca6221abbcb6a11c5824010d854d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9f2dd8cf00c1781743832113a8007a2d84568d752bd77f904bc94e9fb03b342"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8293f5846d99aa4809ba042050feb0824c0514e496f9e9e376fd40fb42b58f8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ed039ef7138e801e1345a025df84954aebdc6426bceef6235f2ccee210cf34"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8f4c7eb8ed0b0579fae78056d2bd33b2605e736d3d6fd4cf696fbf216ae96c3"
    sha256 cellar: :any_skip_relocation, ventura:        "52bbd72d17d9409c98bd6140652085ebd1050a17a9a6a3ea745d9ead57f7b5be"
    sha256 cellar: :any_skip_relocation, monterey:       "524a67d3f14b23f2d185b5f6a9d059a6f09a2df4331a234b97c3dd3581ff2032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c44c2429fb0791cae4dc6c0ac28460d11072e4fd05296fb393068a8a38ae32"
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
