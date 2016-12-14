class Libcap < Formula
  desc "User-space interfaces to POSIX 1003.1e capabilities"
  homepage "https://sites.google.com/site/fullycapable/"
  url "https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz"
  sha256 "693c8ac51e983ee678205571ef272439d83afe62dd8e424ea14ad9790bc35162"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "3892f036977db5de038b2379203c12ccae9beb21841dadbb36c44c047954301c" => :x86_64_linux
  end

  def install
    system "make", "install", "prefix=#{prefix}", "lib=lib", "RAISE_SETFCAP=no"
  end

  test do
    assert_match "usage", shell_output("#{sbin}/getcap 2>&1", 1)
  end
end
