class LinuxHeadersAT68 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.8.12.tar.gz"
  sha256 "1f6134265066aa2bef94103c1e4485d6ed8c2e08ba2a24202ea0c757c6c2c0de"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    skip "Final kernel.org release for 6.8. Consider adding patches from Ubuntu 24.04."
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9607ed3374bbe242f556083e33fa70895dde9d095740b8cdd77adeb4893d6ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d7b3910ec915d32643f07f9ee8e863e63eece4c4f02090899af82482474cfb17"
  end

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
