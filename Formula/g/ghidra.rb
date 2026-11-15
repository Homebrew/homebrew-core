class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.2_build.tar.gz"
  sha256 "ade4fd6e277a10c82db4e75ff5acaeedb3113ef0c7d126ea2c8b38c37128f3c3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f20f3c3ca9eb0a3ce8fa9522b16f251e937f54e33624b8e1e16eabf99a9188e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cee537edc3ede3db751094a5eb02716250d64c78b8036d0ccc2d5b6f2870f8f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42603290241b67c44e61bd05c3c4f17f269c4ef589466d12c0fc6ed32fbcf57c"
    sha256 cellar: :any,                 arm64_linux:       "a423890ed68d0cec935ff9914090ed47340eb2464d59b0df8d9c41749c251586"
    sha256 cellar: :any,                 x86_64_linux:      "b1d670605a0d35241a7b3302e8b599fea64a8e46c572f4b0ab85b3d54e0d30d9"
  end

  depends_on "gradle" => :build
  depends_on "python@3.15" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    inreplace "Ghidra/application.properties", "DEV", "PUBLIC" # Mark as a release
    system "gradle", "-I", "gradle/support/fetchDependencies.gradle"

    system "gradle", "buildNatives"
    system "gradle", "assembleAll"

    libexec.install (buildpath/"build/dist/ghidra_#{version}_PUBLIC").children
    (bin/"ghidraRun").write_env_script libexec/"ghidraRun",
                                       Language::Java.overridable_java_home_env("25")
    (bin/"pyghidraRun").write_env_script libexec/"support/pyghidraRun",
                                         Language::Java.overridable_java_home_env("25")

    # remove incompatible native binaries
    os = OS.mac? ? "mac" : "linux"
    arch = Hardware::CPU.arm? ? "arm_64" : "x86_64"
    (libexec/"GPL/DemanglerGnu/os").children
                                   .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }
    (libexec/"Ghidra/Features").glob("{Decompiler,FileFormats}/os/*")
                               .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}_#{arch}" }
  end

  test do
    (testpath/"analyzeHeadless").write_env_script libexec/"support/analyzeHeadless",
                                                  Language::Java.overridable_java_home_env("25")
    (testpath/"project").mkpath
    system "/bin/bash", testpath/"analyzeHeadless", testpath/"project",
                        "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_path_exists testpath/"project/HomebrewTest.rep"
  end
end
