class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_11.4.1_build.tar.gz"
  sha256 "8a3f955f04f4a2945afc571a70f1c2140052cdd230fbab99615b1de8480ce4f0"
  license "Apache-2.0"

  depends_on "gradle" => :build
  depends_on "make" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk"

  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    prefix.install Dir["build/dist/ghidra_#{version}_PUBLIC/*"]
    bin.install_symlink prefix/"ghidraRun"
  end

  test do
    openjdk = Formula["openjdk"]
    ENV.prepend_path "PATH", openjdk.opt_bin

    (testpath/"project").mkpath
    mkdir("#{HOMEBREW_CACHE}/java_cache")
    system "#{prefix}/support/analyzeHeadless", "#{testpath}/project", "HomebrewTest", "-import", "/bin/bash",
"-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end
