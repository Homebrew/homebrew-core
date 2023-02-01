class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.91.tar.gz"
  sha256 "9aa3a530089259ef1c1e9b24e70bf7c67c0a56f1522dfa838605c2a2f23301a8"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "74d8d15daf4367651a72a46c7abace4cf7d15fac366f1d90670d155f57351c09"
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
