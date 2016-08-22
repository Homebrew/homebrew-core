class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.5.1/pmd-src-5.5.1.zip"
  sha256 "e28ec42e32a004442eb785e925268e5a80addfe4d22da9774be3d1f8306a30e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e435c8772056568a0abc550b87b658ac74281df5154b9e6c117900f725992438" => :el_capitan
    sha256 "bd2f53df48102dbd9c340135a48189c5cf3c5278a99747b651cad0a8c25aa1e0" => :yosemite
    sha256 "f75e243cc2d91b5437fdedd4096c3b1673c2aa389fe86e57120fd6bd79569bdb" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  # Fix doclint errors; see https://sourceforge.net/p/pmd/bugs/1516/
  patch :DATA

  def install
    java_user_home = buildpath/"java_user_home"
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{buildpath}/java_user_home"
    java_cache_repo = HOMEBREW_CACHE/"java_cache/.m2/repository"
    java_cache_repo.mkpath
    (java_user_home/".m2").install_symlink java_cache_repo

    (java_user_home/".m2/toolchains.xml").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF8"?>
      <toolchains>
        <toolchain>
          <type>jdk</type>
          <provides>
            <version>#{ENV["JAVA_HOME"][/((\d\.?)+)\.\d/, 1]}</version>
          </provides>
          <configuration>
            <jdkHome>#{ENV["JAVA_HOME"]}</jdkHome>
          </configuration>
        </toolchain>
        <toolchain>
          <type>jdk</type>
          <provides>
            <version>1.7</version>
          </provides>
          <configuration>
            <jdkHome>#{ENV["JAVA_HOME"]}</jdkHome>
          </configuration>
        </toolchain>
      </toolchains>
    EOS

    system "mvn", "clean", "package"

    doc.install "LICENSE", "NOTICE", "README.md"

    # The mvn package target produces a .zip with all the jars needed for PMD
    safe_system "unzip", buildpath/"pmd-dist/target/pmd-bin-#{version}.zip"
    libexec.install "pmd-bin-#{version}/bin", "pmd-bin-#{version}/lib"

    bin.install_symlink "#{libexec}/bin/run.sh" => "pmd"
    inreplace "#{libexec}/bin/run.sh", "${script_dir}/../lib", "#{libexec}/lib"
  end

  def caveats; <<-EOS.undent
    Run with `pmd` (instead of `run.sh` as described in the documentation).
    EOS
  end

  test do
    (testpath/"java/testClass.java").write <<-EOS.undent
      public class BrewTestClass {
        // dummy constant
        public String SOME_CONST = "foo";

        public boolean doTest () {
          return true;
        }
      }
    EOS

    system "#{bin}/pmd", "pmd", "-d", "#{testpath}/java", "-R",
      "rulesets/java/basic.xml", "-f", "textcolor", "-l", "java"
  end
end

__END__
diff --git a/pom.xml b/pom.xml
index 66bd239..8fb40c5 100644
--- a/pom.xml
+++ b/pom.xml
@@ -277,6 +277,7 @@
         <pmd.dogfood.ruleset>${config.basedir}/src/main/resources/rulesets/internal/dogfood.xml</pmd.dogfood.ruleset>
         <checkstyle.configLocation>${config.basedir}/etc/checkstyle-config.xml</checkstyle.configLocation>
         <checkstyle.suppressionsFile>${config.basedir}/etc/checkstyle-suppressions.xml</checkstyle.suppressionsFile>
+        <additionalparam>-Xdoclint:none</additionalparam>
     </properties>

     <build>
