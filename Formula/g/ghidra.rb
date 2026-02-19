class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.0.3_build.tar.gz"
  sha256 "39e5d160fafa544c8b1858e2df869728d18aa3c9c5490f47a2d0db776f3b4d4d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a19540b97b4616cd71ccdca4097d82f7ee0df793f6e4b2f8ff31d77c08f8116f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323d31884b4beefcc49e7e91ea6bfb8643e171c0cc426f912505220af8dba6b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e942e9f32204146b59e1e8117ac8e673766745e1bbc71b523baf307cdc0095cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b87ec6e633950c319b4c579236fe323f0be57ceca4b49ecfbe9227ddc1944c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1029c78f13732a7bc9d5ad1573997d6b2267e26e24f309d50bd3f335ef9e646b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f32567ffa8ab2abbe2cc2cf108df586fb868787802e10d3d3203e926b7e88105"
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
