class Ghidra < Formula
  desc "Multi-platform software reverse engineering framework"
  homepage "https://github.com/NationalSecurityAgency/ghidra"
  url "https://github.com/NationalSecurityAgency/ghidra/archive/refs/tags/Ghidra_11.4.2_build.tar.gz"
  sha256 "ac2af20b6d20bee37e5238df2566664d824a5a3205db4dacbebdcb62b1394d00"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^Ghidra[._-]v?(\d+(?:\.\d+)+)(?:[._-]build)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9518629ae054a4d76a34e696d093d2bdfd715326e416208161c08169c695944f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f948fe463407c536a6011306760d4f7295e48290c9c86b38400dc37ebfd40d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0888735d7973688766ff936b7ed13a1f711245bab7dd33cf5d011d4db95140b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b57d18d6ad0531fb2734c09701d6466b28bf832812b796efbc318a5af784f4f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55fed6b63fa82614fa304031f0b146734a609bd9d70f061341c431b7a5642142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "912331fe1497aeb0ec144da1db2a0565cbdee945d7eea5048afdacfc298c08a4"
  end

  depends_on "gradle" => :build
  depends_on "python@3.14" => :build
  depends_on "openjdk@21"

  # Allow to build with Python 3.14, remove in next release
  patch do
    url "https://github.com/NationalSecurityAgency/ghidra/commit/5b157d2c26246188d51a7652ac83537efc12cde8.patch?full_index=1"
    sha256 "bb60cb2b36810e4650b71c0a4a3dc7f4fda1aefa809a486ba1d8772f12caa9b9"
  end

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
