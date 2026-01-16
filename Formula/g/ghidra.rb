class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.0.1_build.tar.gz"
  sha256 "f39422da50a7b70ab1f1832bbbbdbe49ba35afe6ca53603110518dc31a6cebcc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e6816482e93fc8a6c20e9fe1d4a322819f9b58450342f9ed50021cc0145bd00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e12be6e9b893c9b3c9af0e2ea34d4060d5f3e53d1655081f4acaa17cfdea75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672bb010b3e7a2d9c8bde56c64885b684025a40bfc076711bd7490d94975dd6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4cff1540502a19f751a18d1237aca02afccf043676a7177ae854251802c8b90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf69fa8161534e8c605e0986c112a23eaad13740016e36a35fc74eb9274c8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bc034702acfe98fb020b0b14d615b505b93f2e5cfbaa32c5b77a416d1ab829"
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
