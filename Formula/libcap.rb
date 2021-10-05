class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.59.tar.xz"
  sha256 "49f64ae40b113e53cbc161e22af7094e3bb4a0611fa33ef5a4257b011779f034"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/"
    regex(/href=.*?libcap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5f21943aa23f98b41b791995dfa7dad7f33cde183e28e4e4aae1006d5d6a38f"
  end

  depends_on :linux

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
