class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.1.4_build.tar.gz"
  sha256 "2a858300c350f05ae2e729dff86b4f584d0b9a6b398879c55025574e67696cec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70f281725bc5340068fa6f39526d17cd7249cf990e950c00458ba53ff0a9020d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2a6222389d18d32d48e55079407c1d877d90f86d692911b0399a6ff5e440a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdaf330d5d9e3a2ad7c58c4cf69c6a145ec8a964c119617d6476f911434d6ca2"
    sha256 cellar: :any,                 arm64_linux:       "b8cca5890f3486247bcf94b329ed2558cf5277ced3de9055cbd59a9e27611321"
    sha256 cellar: :any,                 x86_64_linux:      "1808ba1b278316e6458c0cf8312dc421897f057cbbaf47c7ca3755360a3df121"
  end

  depends_on "gradle" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk@21"

  # Backport Python 3.15 support
  # https://github.com/NationalSecurityAgency/ghidra/commit/864999d7ca67cd3f533be600860f102e54370661
  patch :DATA

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
                                       Language::Java.overridable_java_home_env("21")
    (bin/"pyghidraRun").write_env_script libexec/"support/pyghidraRun",
                                         Language::Java.overridable_java_home_env("21")
  end

  test do
    (testpath/"analyzeHeadless").write_env_script libexec/"support/analyzeHeadless",
                                                  Language::Java.overridable_java_home_env("21")
    (testpath/"project").mkpath
    system "/bin/bash", testpath/"analyzeHeadless", testpath/"project",
                        "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end

__END__
diff --git a/Ghidra/Features/PyGhidra/src/main/py/pyproject.toml b/Ghidra/Features/PyGhidra/src/main/py/pyproject.toml
index c0279e32..bd69e7c1 100644
--- a/Ghidra/Features/PyGhidra/src/main/py/pyproject.toml
+++ b/Ghidra/Features/PyGhidra/src/main/py/pyproject.toml
@@ -28,6 +28,7 @@ classifiers = [
     "Programming Language :: Python :: 3.12",
     "Programming Language :: Python :: 3.13",
     "Programming Language :: Python :: 3.14",
+    "Programming Language :: Python :: 3.15",
 ]
 dependencies = [
     "Jpype1==1.5.2",
diff --git a/Ghidra/application.properties b/Ghidra/application.properties
index 4820860d..ea39af43 100644
--- a/Ghidra/application.properties
+++ b/Ghidra/application.properties
@@ -7,4 +7,4 @@ application.gradle.max=
 application.java.min=21
 application.java.max=
 application.java.compiler=21
-application.python.supported=3.14, 3.13, 3.12, 3.11, 3.10, 3.9
+application.python.supported=3.15, 3.14, 3.13, 3.12, 3.11, 3.10, 3.9
