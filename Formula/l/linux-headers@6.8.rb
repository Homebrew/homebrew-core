class LinuxHeadersAT68 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.12.tar.gz"
  sha256 "1f6134265066aa2bef94103c1e4485d6ed8c2e08ba2a24202ea0c757c6c2c0de"
  license "GPL-2.0-only"

  livecheck do
    skip "Final kernel.org release for 6.8. Consider adding patches from Ubuntu 24.04."
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "64614bcba5f4d9b9535bdd54b68a588aa2c9f56f78fa048b60ddb6e98a21aea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f3000358f22ee25e733aa9dcf0881b5ec4f3c2805372d4fbe988039deaa1fef"
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
