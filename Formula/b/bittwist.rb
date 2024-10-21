class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%204.3/bittwist-macos-4.3.tar.gz"
  sha256 "ef01c05de9ccf6010583bf0c3ff482f1bf38ad5872f2ad1bef63152b6719f1fb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76eebee0ed9d7422fc89791c3023c91f06f29e6fbba0eeffa3d5c5c3403635fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf89febd3bc2e7a9ce1c17cb5821f60389b9bc67b8e0a22094132cd23ad13da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31f7c3e150a9d4c4267d206ece56f0c232601c76132a3342c9d42fe1ac49916f"
    sha256 cellar: :any_skip_relocation, sonoma:        "72e7b968f8c8f65f3f45e305543480c3eff42e7094b6fc65bbcbfa3c2ef01a64"
    sha256 cellar: :any_skip_relocation, ventura:       "79a83e33cdd8cef8b2ec0adfaf3976c5314b874d7a35c3d1101401d4bb33b604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a478c926c21b2eecef736f53199c2813c40f7051a53252c3ea0e79dd669ec2"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"bittwist", "-help"
    system bin/"bittwiste", "-help"
  end
end
