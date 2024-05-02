class Dpcmd < Formula
  desc "Linux software for DediProg SF100/SF600"
  homepage "https://github.com/DediProgSW/SF100Linux"
  url "https://github.com/DediProgSW/SF100Linux/archive/refs/tags/V1.14.20.x.tar.gz"
  sha256 "d3e710c2a4361b7a82e1fee6189e88a6a6ea149738c9cb95409f0a683e90366e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "dpcmd"
  end

  test do
    # Try and read from a device that isn't connected
    assert_match version.to_s, shell_output("#{bin}/dpcmd -rSTDOUT -a0x100 -l0x23", 1)
  end
end
