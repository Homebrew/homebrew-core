class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.180.tar.gz"
  sha256 "a4713a2bcb229722756ea54a80866b98bf4416bc3db6b72a5afb15a0c1105f0c"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "9d954e1bac1f0bd49fea1178d211815987dff07f1b6ccf2c9f50e2cd12abbcd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ed0b276a5ecd33f5082273e4d0ae4147fc90f74e6a2aa2e7d2526030d1f83cc6"
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
