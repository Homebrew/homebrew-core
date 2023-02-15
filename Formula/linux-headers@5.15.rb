class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.94.tar.gz"
  sha256 "c0c0e1013863e17a0a29e24e8505188a345b64e988ca69ee920dd56facdb8d43"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "48c3fe20edcaa69da32a63fdccb6aa6fa43aea7709bc2d1ca7d79de7e77b2089"
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
