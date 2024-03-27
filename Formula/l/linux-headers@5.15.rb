class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.153.tar.gz"
  sha256 "7487308933c83a8bfb672ce3c0efa4b090bb34a9c8316ef044432786dd4f756c"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a37598a72230b6f4f424796306b19cca135805a430fe176806f77024953ac4a5"
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
