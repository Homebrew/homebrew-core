class Pixiewps < Formula
  desc "Offline Wi-Fi Protected Setup brute-force utility"
  homepage "https://github.com/wiire-a/pixiewps"
  url "https://github.com/wiire-a/pixiewps/releases/download/v1.4.2/pixiewps-1.4.2.tar.xz"
  sha256 "c4dc0569e476ebdbd85992da2d1ff799db97ed0040da9dc44e13d08a97a9de1e"
  license "GPL-3.0-or-later"
  head "https://github.com/wiire-a/pixiewps.git", branch: "master"
  
  depends_on "openssl@3"
  
  def install
    inreplace "Makefile", "/usr/local", prefix.to_s
    
    system "make", "OPENSSL=1", "install"
  end
  
  test do
    assert_match version.to_s, shell_output("#{bin}/pixiewps --version 2>/dev/null", 3)
  end
end
