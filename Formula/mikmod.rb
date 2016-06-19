class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "http://mikmod.raphnet.net/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.7/mikmod-3.2.7.tar.gz"
  sha256 "5f398d5a5ccee2ce331036514857ac7e13a5644267a13fb11f5a7209cf709264"

  bottle do
    revision 1
    sha256 "72bc9ddab041d72dbb3c8a09093c64ecc2c19346a3dcf1e9409311db1e6ff497" => :el_capitan
    sha256 "b881f86816e66413b6eefa1b5e35e2f87a80559532060e7944504f73be68ab88" => :yosemite
    sha256 "1a8649c6c9e8e9f69616e5ac525bdb31fd45a6a01b0a949df8ac4476244dda41" => :mavericks
  end

  depends_on "libmikmod"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
