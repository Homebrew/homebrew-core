class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse/org.aspectj/releases/download/V1_9_9_1/aspectj-1.9.9.1.jar"
  sha256 "922310b843d7a12a4752222791f62cadf08071273a997e364d12016de210856b"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36a67f2b95ab664069d3afdab7b9aad777eae0d0ded35ddbee65706c430eeb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5010ad23271abcd2710611ebea6d5e45e261fbfa3eab099a1f6cdbb1a132aaa2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0b87f4d7fd11196fda90236d0c85eea8ddddc8d646e030f731b7a85729f5d1"
    sha256 cellar: :any_skip_relocation, ventura:        "b20d4962c09197d2f49f597506cac16dd8ae5ec895707db5d6d476bbb2ff64ce"
    sha256 cellar: :any_skip_relocation, monterey:       "5b0871adb51c137ab4dcef34e4f59be0313a21c4f560352b50ef32e9429fd946"
    sha256 cellar: :any_skip_relocation, big_sur:        "78dadaa0a4eb9536adb1e506452e5dd78bb65a5bfd293035a1e14f62565323cd"
    sha256 cellar: :any_skip_relocation, catalina:       "e4a9d574a1bd6153c5a903a925da7c668590951641e6c20d6c8048a95c2d241f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62ece6e63e0c945228e7046599684aef183bd3c615a0f65929aecaed8fa4816"
  end

  depends_on "openjdk"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "#{Formula["openjdk"].bin}/java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
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
