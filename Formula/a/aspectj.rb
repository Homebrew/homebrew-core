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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cca7d183145526bebc54ce8d5408cd6521603c7228f0f1fb5319e6e8174214b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0032c33a3cbbe8c58346f17908a19efda29d477533595ea720424397d600631b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abaf01d34962c258328b02e3282f8a99dc6d981a853349711202ca14fbafeb33"
    sha256 cellar: :any_skip_relocation, sonoma:         "47e8c87fafe0254526b194514dfe9bf7f87b0dfd5c800edc4c19ddc523937156"
    sha256 cellar: :any_skip_relocation, ventura:        "c086be5d0f06d7798fe4734612fb5af854a8cab53fe0a271e8f6cccf4f00a059"
    sha256 cellar: :any_skip_relocation, monterey:       "a17580487cf2285df118ef12d0906e421471d59de74340c9c11cbdb0dec3f3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687ec794bbc3ba1bd8e44fe7a517ae2fdb5fd3ea0e589b3f8977c045b130206c"
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
