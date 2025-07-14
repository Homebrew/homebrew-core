class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.188.tar.gz"
  sha256 "e5d4f1d57cc07130cdd92ef8ad8cce44aa140dfae2bbc43089784a8a303b7836"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c56fc8932a91e5050db818339007ac9cdd609409a8a635b29d5408036dd7aaa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "12eccb5e7b638cb49de408ef4cb79134e8c5c7db68042e858672fc3e0642fc99"
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
