class Pmd < Formula
  desc "Source code analyzer for Java, JavaScript, and more"
  homepage "https://pmd.github.io"
  url "https://github.com/pmd/pmd/releases/download/pmd_releases/5.5.0/pmd-src-5.5.0.zip"
  sha256 "825d9061754cef30fc1b4584f509c7dd8a7b023a2c6ec264bf7b82bb0615c0b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "200b328de630494f9af715dea361f58a33cbe63f05f92655e24fa303718081ec" => :el_capitan
    sha256 "e77b25de6a13bb512d2962eab1d643d76ac7411f18bf38f049774d193ccfd43c" => :yosemite
    sha256 "e5ed61e35b5c980b0e1bcf616bc2615f1c5310ad66ce8f4901ca225764e7e78c" => :mavericks
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

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
