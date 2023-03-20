class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.67.tar.xz"
  sha256 "ce9b22fdc271beb6dae7543da5f74cf24cb82e6848cfd088a5a069dec5ea5198"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c176235b593bff16392580d44d2b72118d6ab5a438abc73580a63f1112694164"
  end

  depends_on :linux

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
