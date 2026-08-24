class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.1.3_build.tar.gz"
  sha256 "474e327d27fa87aeea9fff8f842351d229a3c8e7a07c02ce3ac53141b79057c2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11dbbd3b531c84d74560c43c35fa79c2581be71303c3a917ba614f52120c5028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13b50282999f82a52e881a7f0d947cf85fafb3773b829a1ee90305e47253258d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902d39e245123ed991081801b67edd5b271c3d35573c353c9462d018463780dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdb2693de04dbafd7c2cde11869fb3bee821d558eb704739ece5405d45a46188"
    sha256 cellar: :any,                 arm64_linux:   "58bad99dcc15a626545e390f5ebde72c98b01ebfac412474bd28a7f3a2acf4d5"
    sha256 cellar: :any,                 x86_64_linux:  "5aabf2edd2f8337b0d78d9124a853f6049e6b6146341f2049b18fa9af4f2a4df"
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
