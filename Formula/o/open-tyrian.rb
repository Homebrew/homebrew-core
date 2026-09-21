class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://github.com/opentyrian/opentyrian/archive/refs/tags/v2.1.20260913.tar.gz"
  sha256 "dbcd96383d4fa571137242c36bd7eca054cf5a08a9bf2eec15ef230d6e60680d"
  license "GPL-2.0-or-later"
  head "https://github.com/opentyrian/opentyrian.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "50321ad12a5de87cdf59e63584c9e3bdbc46242f60349b26fa21115293c27ae6"
    sha256 arm64_tahoe:       "a367545bba9fcd03b3894a1768523704e3728903ab1e2ae5a26820c5f307e5dd"
    sha256 arm64_sequoia:     "049fab6183403a11363acdbd0096b8209446dabb641a1c01433564a98313f959"
    sha256 arm64_linux:       "89b9144e673d26cd2a309ffca6781402367abfd0479c436c3281a94ceb7c66b7"
    sha256 x86_64_linux:      "c5f46eac379e10dc84aae4be8b47d158a955b1ebb9c0fbe1506da54f1b01eccf"
  end

  depends_on "pkgconf" => :build
  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  resource "homebrew-test-data" do
    url "https://www.camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("homebrew-test-data")
    system "make", "TYRIAN_DIR=#{datadir}"
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system bin/"opentyrian", "--help"
  end
end
