class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.5.4/pmd-src-5.5.4.zip"
  sha256 "b4dc8c9cc42e7df09119b662358a33ac7e365753931abf8e9e22d01d5d5aa861"

  bottle do
    cellar :any_skip_relocation
    sha256 "849633a9db5bac7ba0f96250915eb00da57c99c8ba1aac801d892865049d6d26" => :sierra
    sha256 "88eeee37348ac2e21b61539d0fbbcae1b04863ab21ff5d6885653181ba2635bf" => :el_capitan
    sha256 "200ce725f20f807e82a6fc4f6d7d10edefca993ec5b485fdcda475da1d44d04d" => :yosemite
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
