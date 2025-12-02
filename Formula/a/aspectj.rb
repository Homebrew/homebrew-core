class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://eclipse.dev/aspectj/"
  url "https://github.com/eclipse-aspectj/aspectj/releases/download/V1_9_25/aspectj-1.9.25.jar"
  sha256 "0190878539658cdaa654b422f56cf294183c2e5570ecd16cfc3aa2ddd5226fed"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1fd9555e4ca8396b8a5770363bb8bc48b18c1d846fa790b9ce0c6fea5561d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886591ea57644b9d9ef1f1b7712878e11eca18cf86745ece3c5b73a41649d63d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2ddf5ffe417f503602d12f07c8af6aaf813243c4082958188a03692d93a5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb25223230d39ca2bef3bb0b84ee209236abe38d5180a5e194564cb9dd2afb7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bbfd48bf13bc58c0f623ad703f8ef8f517a9d2b6e30c095d252c2ab2170a335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18df22d9d90b37312e0c3af0692dd4559f725c9a71442eebf420a5d69815eee7"
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
