class Cbonsai < Formula
  desc "Console Bonsai is a bonsai tree generator, written in C using ncurses"
  homepage "https://gitlab.com/jallbrit/cbonsai"
  url "https://gitlab.com/jallbrit/cbonsai/-/archive/v1.3.1/cbonsai-v1.3.1.tar.gz"
  sha256 "62aa7e0eaf3098b7a6a2787146bd2531437df6ad0e604b0f9176128797efd8f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b7f0d998d2d9d8c57df4af660020fad67ca426ad8ede10842301f0cdf4ced6e2"
    sha256 cellar: :any,                 arm64_sonoma:   "d751d0aff3de34a8d5f64a063a16d632fcf4aeb3decd78eccc89e50de7363057"
    sha256 cellar: :any,                 arm64_ventura:  "5606c2d1882991d15e4e0e6457b258d2580caff4af08ff15f9019a9375d9d0af"
    sha256 cellar: :any,                 arm64_monterey: "29f707c8334b23505e9f1963f9bc408038357402602df228ef1697a2e02ef16e"
    sha256 cellar: :any,                 arm64_big_sur:  "fa7453507eea38ba79fcfa206508a405db0d5f3d38498e90e7bd63200d16c7b8"
    sha256 cellar: :any,                 sonoma:         "f54742a3e343c6989e25f3ca484b24a798654b514e64505a1d2fb4e1fca3af5d"
    sha256 cellar: :any,                 ventura:        "7d51969cb0c181d86ddb3fccb770efdfcf2f438e1a2cefc758fcc2dc166219c0"
    sha256 cellar: :any,                 monterey:       "559b47b52fd88c4755a176832ad90b86499807aa91fb23919b0b529734dd8a39"
    sha256 cellar: :any,                 big_sur:        "f09aa06b6ea26cd7053de48b25c11a2a517d05fc7f40b61a024164868f42bedd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f88dc991a65cfc6b31775e38ad0e4043443e4bce345ac6691e3fa116d9bc5dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adab516beb445c4f2f03666bef052c660e3484c1f9e252d27c0741f91b2f40fb"
  end

  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"cbonsai", "-p"
  end
end
