class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.5.6/pmd-src-5.5.6.zip"
  sha256 "39b9476ae45f56505548f2aca54f88a59cbd663e3325eb2c88e2963cc83dc5dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f2adbbe48be42531e9896fdd4d42feafbc35331c0adfd2a3abc85b34aeacb7d" => :sierra
    sha256 "8c3e45309f32691b6b495be4bc22730850de486f14d60a01d81f4c70582ea2b5" => :el_capitan
    sha256 "396426b55390978ff42eec59d42fcdf76453171c1e7184590b9551862ebe2707" => :yosemite
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
