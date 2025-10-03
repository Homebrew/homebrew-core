class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.194.tar.gz"
  sha256 "2627970ae0307ce8288955098eadbc260a276e1b97feb101a20d01c274415346"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "84c30f751c03c3f99b8eb06e00c77f450026876bf6b169bf8572c9ac1867499b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b892d4b1d4690028fde43729118f2403b026a790acec01f7194616c46a92bfc5"
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
