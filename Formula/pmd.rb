class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.5.5/pmd-src-5.5.5.zip"
  sha256 "58018333ad6c4790de0909d7daa777f02744f10898de9d777d03ba4fd98ac7e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e544b98de6eab81dcc7b53864e69ef89cffba83ec57ddeb221f8588cd527530b" => :sierra
    sha256 "a52b844abf406abe31a9250a6e729a4409587a49ec4cca8b5df80fbe228ad85e" => :el_capitan
    sha256 "35092e51a2a7719a7d3e6ec14f47c36cfedd39f92f30caeee259d79aad4a715a" => :yosemite
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
