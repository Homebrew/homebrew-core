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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebf487d4b8d81dce759bf069f43008788d3f79de534e1a3c658ecd7cad97d58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a0188d43ca6b1e108752381a1f9b0f8dc4f3424c0151b0daa21896d480257b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a589ce90ef47f1971fe87b5f12f93abac50cad69b5583f1a6a96e9f51f369b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52bce83f468089abc2cdc4f7ec37c3da201fbfea86b1a18caac02ffc08d15e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b14662788f6044b1aaeb82bab63d70894ebf725a405efb5f1b0addd2174168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c304a0f8fc1d50ef2eb74e862109aa1338af079d2ee992562ec4521efca419f"
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
