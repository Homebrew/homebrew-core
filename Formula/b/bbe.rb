class Bbe < Formula
  desc "Sed-like editor for binary files"
  homepage "https://sourceforge.net/projects/bbe-/"
  url "https://downloads.sourceforge.net/project/bbe-/bbe/0.2.2/bbe-0.2.2.tar.gz"
  sha256 "baaeaf5775a6d9bceb594ea100c8f45a677a0a7d07529fa573ba0842226edddb"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1c7ca0dd8b2f4c9161de533964c1d783b3e09c9a108880d87236db9a7401eab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095d439542aced7baf7f5994fe1d8ca64da82039222c1c083d09262cf559d4a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7181a956a065ea4b793431041e45cc04d217a7c64a579dcf1c7078249ee579ab"
    sha256 cellar: :any_skip_relocation, ventura:        "81e9cc86f064e0e4a4b7dd44b6752a8f8643ba70dca6f08ae66dce92d4de58bd"
    sha256 cellar: :any_skip_relocation, monterey:       "1a2799215e2d472a9ae04a451e486da0853b2861e3e9e04d274c8ba5e0c30f30"
    sha256 cellar: :any_skip_relocation, big_sur:        "677a07ce2e73761b8403033706a969d15bd89f98401054dccae350c0d9acdf6b"
    sha256 cellar: :any_skip_relocation, catalina:       "16ec8602703755894016b9ecd47ca9875a97c66ba259cdb8d7fa8902a17dd8d3"
    sha256 cellar: :any_skip_relocation, mojave:         "f1c5c6884c5e1740d5f649ac1caa4bb42df1a5ab6bba13970497f7c94454d346"
    sha256 cellar: :any_skip_relocation, high_sierra:    "95cef154264d814bcdb543da64b8947ed8219411c3da20d854f30bd0aeb1332a"
    sha256 cellar: :any_skip_relocation, sierra:         "4f533ae33e0c46a01bc11f1c8b99ef6baba62a376ddee1000de1fa199f18545a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d9c63d7b9657e6f1c0e53048564f275283177e3513e202a7a9cfc69571bb5008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b683897c9241114a529a017dafad699e55a4bc3f19f1e3ef9bed408c8ee6c72f"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bbe", "--version"
  end
end
