class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://www.nsa.gov/ghidra"
  version "11.3.2"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_#{version}_build.tar.gz"
  sha256 "cb456614e125fc9958bc46104d3e6d688f718a79bbb81da850a1f3719f2fc4b6"
  license "Apache-2.0"

  depends_on "gcc" => :build # Ghidra build system also supports g++ and clang
  depends_on "gradle" => :build
  depends_on "make" => :build
  depends_on "python@3.13" => :build
  depends_on "openjdk"
  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"
    system "gradle", "buildNatives"
    system "gradle", "assembleAll"

    prefix.install Dir["build/dist/ghidra_#{version}_PUBLIC/*"]
    bin.install_symlink prefix/"ghidraRun"
  end

  test do
    (testpath/"project").mkpath
    mkdir("#{HOMEBREW_CACHE}/java_cache")
    system "#{prefix}/support/analyzeHeadless", "#{testpath}/project", "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end
