class H265Repack < Formula
  desc "Tool for repacking videos to H.265 format"
  homepage "https://github.com/TheBluWiz/H265Repack"
  url "https://github.com/TheBluWiz/H265Repack/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "215cad95db6594ba545d8787aff52d96fc20c9530bc65a4ce1ce1fa3bbbd63d8" # Replace with the actual checksum
  license "GPL-3.0-or-later"

  depends_on "bash"
  depends_on "ffmpeg"
  depends_on "findutils"

  def install
    if OS.mac?
      bin.install "bin/H265RepackMac.sh" => "H265Repack"
    elsif OS.linux?
      bin.install "bin/H265RepackLinux.sh" => "H265Repack"
    end
    man1.install "man/H265Repack.1"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/H265Repack --help")
  end
end
