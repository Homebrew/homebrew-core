class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_12.1.2_build.tar.gz"
  sha256 "c30fe709ec5d5e68bf799a6c1f4dfc6853dacb189d10203eb882ecbb408db216"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "079007d8a3a477c8d5901e6596947612d86c8641956424a2bcb71ecd798bedcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90aa942184fca2337ad0a123f818f37372ea642e8e69e969d45cc144a6f26fdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f68357d6b62a08429c36228907c995e3449283b6d2e08ba5a4e30b53a09725"
    sha256 cellar: :any_skip_relocation, sonoma:        "e30f8c84b64331f87f6ef1890cbdded6672bb7fcc8b674794ac93e4b3e62ad2b"
    sha256 cellar: :any,                 arm64_linux:   "95bb260cc1a7986a7c25135f4c78b51ff5c604474aa41b77466323a40ee03ea5"
    sha256 cellar: :any,                 x86_64_linux:  "038f29e336c2e2a796abb10f62ecf58d3e1d6af3ee36af710d5254f7494b51eb"
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
