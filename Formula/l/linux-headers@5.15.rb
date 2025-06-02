class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.184.tar.gz"
  sha256 "f0442b1d6384bb3462fa4b96c6df7fd54b02bc0d744df127e90af347eea32b0e"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "eac07d2d791d6bdec2142a323f964da8384a9e17781ded76b0afb41bf18038be"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "32ce1c2f0c448c033cf74a77f019e7cbfd68f4f52b2fea1314aa687a788b49a4"
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
