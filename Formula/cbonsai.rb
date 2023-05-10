class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://gitlab.com/jallbrit/cbonsai"
  url "https://gitlab.com/jallbrit/cbonsai/-/archive/v1.3.1/cbonsai-v1.3.1.tar.gz"
  sha256 "62aa7e0eaf3098b7a6a2787146bd2531437df6ad0e604b0f9176128797efd8f9"
  license "GPL-3.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "scdoc" => :build
  depends_on "ncurses"

  def install
    system "make", "install"
  end

  test do
    system bin/"cbonsai", "-p"
  end
end
