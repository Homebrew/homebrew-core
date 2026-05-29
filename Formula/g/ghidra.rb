class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.1_build.tar.gz"
  sha256 "bbe3cf874db010516c5170db0a206dce3496680cec3460890271c6a1ed4f6719"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321b2e627762f4b19e859d1336eedba4db7fcef384aff2a50e5a3f6ab0dbfafb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8df8af6ed06ecfb53b470566d2e1311d22e77111a973504281fed991932775d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850b27189d2acbb24e9ad02b629b0ee4ee772f0ea74993045d4def039762965f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b5ff189b715423c2275a31b5d1c8f18c35e088355b39f5eac3e50f459165c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad5e79ee64986bc805a76ad4bcdd22d3cff6012bb1ac61a333876f5db59a7fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b575ceb6616db277b7355f82eb4d86a1fb2e659e3f0a9e0a9b23b32d5481d585"
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
