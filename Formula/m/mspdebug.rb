class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "https://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/refs/tags/v0.26.tar.gz"
  sha256 "9e2c1562adeee79c73d75f0521032b01543163772f5ec30a7d6e9f6d708214b8"
  license "GPL-2.0-or-later"
  head "https://github.com/dlbeer/mspdebug.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "951ce1dd56ff8622c0ea45cdeb334e1e1cf4bcb592684e4c2a571621b91a763c"
    sha256                               arm64_sequoia: "59160aae0981c9f56eba3a0cf4645dfc2cb806f6826d4f9c1dca33bfaf033104"
    sha256                               arm64_sonoma:  "ba9363ad723663a76d36ea12cf2ff84d221d98d27bf0fc9a0cd3f963e29344eb"
    sha256                               sonoma:        "249e03dfe230e9285a7f01f10998f9a9de49318ec5d34e6fe6084301bac623af"
    sha256                               arm64_linux:   "37d7c174a32eef149e2fb86b166beacecae8aedd98c10c652a2ac39764db9bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d9d737369d456925430120592413c6e75c1318775bdbb0b0cc94d8be79f533"
  end

  depends_on "hidapi"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["hidapi"].opt_include}/hidapi"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      You may need to install a kernel extension if you're having trouble with
      RF2500-like devices such as the TI Launchpad:
        https://dlbeer.co.nz/mspdebug/faq.html#rf2500_osx
    EOS
  end

  test do
    system bin/"mspdebug", "--help"
  end
end
