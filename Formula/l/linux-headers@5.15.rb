class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.197.tar.gz"
  sha256 "1a2718e05bb1734c56c058a1301c2e0a6ab784034ab9afd2ef7be8883c56c435"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "43c55f5b4053b23af95a0d2926bd88242b231a92b49093be7839b03d2ccacb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "afdbc6b7273567e31320249fbc9d75915e7546de67a7ed86f6621206edc111e9"
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
