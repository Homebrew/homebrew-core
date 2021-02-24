class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/conserver/conserver/releases/download/v8.2.6/conserver-8.2.6.tar.gz"
  sha256 "33b976a909c6bce8a1290810e26e92bfa16c39bca19e1f8e06d5d768ae940734"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a036894fc4d2c15c84b62906e56bd65a1d4b6354d57195f232c5112dbaaf59b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "35fc01a42164ba7af8f73497fbd25c0f4193580e2ca93d0e33683a0d0c1d0ffa"
    sha256 cellar: :any_skip_relocation, catalina:      "eaa811a62521fd8f6f33af9837d03f42dedb218021d64390b8e9ece105e928c1"
    sha256 cellar: :any_skip_relocation, mojave:        "03290cfe6fffbbb28d16b526a9667bc321cf048f32c947fbc9c20787bd67ed7b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "71080dd0b8f5cf10c4c2e9aa935d48cf6f458f7bd926c59a7087108129a83ac7"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
