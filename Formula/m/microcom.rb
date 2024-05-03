class Microcom < Formula
  desc "Minimalistic terminal program for communicating over a serial connection"
  homepage "https://github.com/pengutronix/microcom/"
  url "https://github.com/pengutronix/microcom/releases/download/v2023.09.0/microcom-2023.09.0.tar.xz"
  sha256 "ef42184bb35c9762b3e9c70748696f7478efacad8412a88aaf2d9a6a500231a1"
  license "GPL-2.0-only"

  depends_on "readline"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/microcom", "--version"
  end
end
