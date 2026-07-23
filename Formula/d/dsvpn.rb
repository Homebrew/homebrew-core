class Dsvpn < Formula
  desc "Dead Simple VPN"
  homepage "https://github.com/jedisct1/dsvpn"
  url "https://github.com/jedisct1/dsvpn/archive/refs/tags/0.1.5.tar.gz"
  sha256 "53c9ff2518acea188926a4f10d38929da7b61b6770d6ec00f73a4c82ff918c5e"
  license "MIT"
  head "https://github.com/jedisct1/dsvpn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06ad6babce8270f21d7b98ea3e7aaac1b2bcfa4815b39b75561de68193149a9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78343612a40f3a9ba3c70ad6339c69e04c18262d54da9cc22c550fbc63dbe949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d45aa8e155e087221a37d22bdb86b86eff6ff721f0a711082c87d2b9d5781a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "db2467dae361b23cdfc06e2a98a4d64f987b8a314d74eb2a3e54087c0e55e142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d67ee9ff361e38d1f7c78f22c110b4f07d7a00568f6327254a3c2fe326f72e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4329c90e50ec594f40ba135a486f53781a838491792f72f0e2be6b5997df7af"
  end

  def install
    sbin.mkpath
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      dsvpn requires root privileges so you will need to run `sudo #{HOMEBREW_PREFIX}/sbin/dsvpn`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "tun device creation: Operation not permitted"
    else
      "Unable to automatically determine the gateway IP"
    end
    assert_match expected, shell_output("#{sbin}/dsvpn client /dev/zero 127.0.0.1 0 2>&1", 1)
  end
end
