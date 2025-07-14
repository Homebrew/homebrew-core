class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.76.tar.xz"
  sha256 "629da4ab29900d0f7fcc36227073743119925fd711c99a1689bbf5c9b40c8e6f"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "daf16aeef1862c06a0fb6fea160d8a9f7ccf14a4459ff21e2ddf1c8904bef9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1b39367526d90d20f2456fa3a443f12b2b80f325dcd0c7d755d2136ce824541"
  end

  depends_on :linux

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
