class Cpufetch < Formula
  desc "CPU architecture fetching tool"
  homepage "https://github.com/Dr-Noob/cpufetch"
  url "https://github.com/Dr-Noob/cpufetch/archive/refs/tags/v1.07.tar.gz"
  sha256 "dc3ec8f9c9d41d8434702a778cc150b196d5d178fd768a964f57d22f268a2c17"
  license "GPL-2.0-only"
  head "https://github.com/Dr-Noob/cpufetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbdea8515700936d548b6baab978624be7e9fcc94dd3121a5962d58074cec48c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1b091ed4c78aede110a601f2f57ced0b6c30754f1032d284d613b3bd3a3ab78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e068fc8cc1764d15ecf55a8e01e80a3780070f1808b331e88679c74b593045a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0554f98200441b7743a72bfe61a55f753c2d19f56d8af453924248da7efb7db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d1bcfcfcb32100c81cf2c17b3e8a9c08c1260935f8572db1a7f3e8ace87a3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5544e250a55c6c3506d74586d7d566194dbbba1c97bb6b10acacc5ede672ebe3"
  end

  # Compile with `src/common/sysctl.c` on x86_64 Macs
  # https://github.com/Dr-Noob/cpufetch/issues/375
  patch :DATA

  def install
    system "make"
    bin.install "cpufetch"
    man1.install "cpufetch.1"
  end

  test do
    # This fails in our Docker container.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"].present? && OS.linux?

    ephemeral_arm = ENV["HOMEBREW_GITHUB_ACTIONS"].present? &&
                    Hardware::CPU.arm? &&
                    OS.mac? &&
                    MacOS.version > :big_sur
    expected_result, line = if ephemeral_arm
      [1, 1]
    elsif OS.mac? && Hardware::CPU.intel?
      [0, 1]
    else
      [0, 0]
    end
    actual = shell_output("#{bin}/cpufetch --debug 2>&1", expected_result).lines[line].strip

    system_name = OS.mac? ? "macOS" : OS.kernel_name
    arch = (OS.mac? && Hardware::CPU.arm?) ? "ARM" : "x86 / x86_64"
    expected = "cpufetch v#{version} (#{system_name} #{arch} build)"

    assert_match expected, actual
  end
end

__END__
diff --git a/Makefile b/Makefile
index d07f036..c88baba 100644
--- a/Makefile
+++ b/Makefile
@@ -20,6 +20,11 @@ ifneq ($(OS),Windows_NT)
 		COMMON_HDR += $(SRC_COMMON)freq.h
 	endif
 
+	ifeq ($(os), Darwin)
+		SOURCE += $(SRC_COMMON)sysctl.c
+		HEADERS += $(SRC_COMMON)sysctl.h
+	endif
+
 	ifeq ($(arch), $(filter $(arch), x86_64 amd64 i386 i486 i586 i686))
 		SRC_DIR=src/x86/
 		SOURCE += $(COMMON_SRC) $(SRC_DIR)cpuid.c $(SRC_DIR)apic.c $(SRC_DIR)cpuid_asm.c $(SRC_DIR)uarch.c
@@ -51,11 +56,6 @@ ifneq ($(OS),Windows_NT)
 		ifeq ($(is_sve_flag_supported), yes)
 			SVE_FLAGS += -march=armv8-a+sve
 		endif
-
-		ifeq ($(os), Darwin)
-			SOURCE += $(SRC_COMMON)sysctl.c
-			HEADERS += $(SRC_COMMON)sysctl.h
-		endif
 	else ifeq ($(arch), $(filter $(arch), riscv64 riscv32))
 		SRC_DIR=src/riscv/
 		SOURCE += $(COMMON_SRC) $(SRC_DIR)riscv.c $(SRC_DIR)uarch.c $(SRC_COMMON)soc.c $(SRC_DIR)soc.c $(SRC_DIR)udev.c
