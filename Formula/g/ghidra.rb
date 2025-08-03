class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_11.4.1_build.tar.gz"
  sha256 "8a3f955f04f4a2945afc571a70f1c2140052cdd230fbab99615b1de8480ce4f0"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk"

  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"bin/ghidraRun", Language::Java.overridable_java_home_env("21+")
  end
  test do
    ENV["JAVA_HOME"] = Language::Java.java_home("21+")
    (testpath/"project").mkpath
    system libexec/"support/analyzeHeadless", testpath/"project", "HomebrewTest", "-import", "/bin/bash",
"-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end
