class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.86.tar.gz"
  sha256 "acd450838f720c39659aada8f06a3b4d8c237ab6147cad597e016205dab966e6"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a28b429df4a56d3376df0c8ddc6f70f992ac3d11c37caa61e4a60ac376f62378"
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
