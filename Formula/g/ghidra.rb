class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.0.4_build.tar.gz"
  sha256 "2650b5c5f2615883db347157f88d15f6f06cd14e223156cd6b6034264081f5b4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b127dc5cd7460a62937fb94341221b53d2cb424f713482fa69d3412e05b6b779"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e030d0d082c0dc6d2b5c6669671719b8d619e3c9db082021966cc1b05dfb8e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61979e62e4a3a36fea845664f087e75de1aa7563271f298ef888a1c9ab951ddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2100cf3fe75867af53608f21896de0856b4c179db2814acd5ef89fb24e885c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2801dc27010ed14f2e7ea64ebe5d4088bacee2ae454abb8eafb6d4c839cfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51f334661eac028aa05eb5108e240385db0dfb493ce50f6e18a013f8dc59194d"
  end

  depends_on "gradle" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk@21"

  def install
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll", "-x", "FileFormats:extractSevenZipNativeLibs"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
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
