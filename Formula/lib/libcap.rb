class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.78.tar.xz"
  sha256 "0d621e562fd932ccf67b9660fb018e468a683d7b827541df27813228c996bb11"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "ace490a7344980dcb006d0f32699648006b8fdfd5ac51de04c6106d142ef467e"
    sha256 cellar: :any, x86_64_linux: "18ad05f305a2ce9c296a0651d06a475788c435e10aec75924838d40fc67c516b"
  end

  depends_on :linux

  deny_network_access!

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
