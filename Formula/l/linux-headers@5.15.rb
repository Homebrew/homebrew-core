class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.209.tar.gz"
  sha256 "89e14eb54cf4dfa1779fbe58da72b85dd6deb2fa8535252d87d36984fc5eb6ca"
  license "GPL-2.0-only" => { with: "Linux-syscall-note" }
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a5df93d9f09bcaa52f90877a14ded22beafa4d8defd2904f14f9f2ccc76c8fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "59d973cca8c9fdc34185350ae907ae4b7501b4759832011b0cbfd4c6bf12b66e"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
