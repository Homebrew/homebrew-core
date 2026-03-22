class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.93.tar.gz"
  sha256 "132d74c1a8cf56023a16ddd39d10c89b4dfa0acdbd7c472e45ccc8521d8aaddd"
  license "VOSTROM"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d61632f71eccd5cf1aed7004ac9554e28e71d875af82c0a8428ca90a0264e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6713ecedde735671713399c2cc2640f6bb5310adb6e3865394a6c584afe02bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb3e176fe2d0711558222f080dce599d592d3cef6016352a36bf32aa1432213d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5716adbf89ee9d65ac6f35ae16bf6005e72c6fdd58ef8f4902ee58448ebb5c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "286743a2447c36a183b14cc7547a7b782b517a428022cbe3c97e8903c0328252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae83d99648c69a603c70695e15f6610d716a64597479edcfbca17c7233c4d8c3"
  end

  uses_from_macos "libpcap"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "isn't available to LFT", shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1")
  end
end
