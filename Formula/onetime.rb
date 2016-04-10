class Onetime < Formula
  desc "Encryption with one-time pads"
  homepage "http://red-bean.com/onetime/"
  url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
  sha256 "36a83a83ac9f4018278bf48e868af00f3326b853229fae7e43b38d167e628348"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "4d27502d9a4b8d257182dcaf99b05121033352928c3716a1ebe932a24276e73a" => :el_capitan
    sha256 "4e914d9a8d176f3505ae88d5eff3eb905c1a5f9005cf3d62aadaeae9bb6cbc28" => :mavericks
  end

  devel do
    url "http://red-bean.com/onetime/onetime-2.0-beta3.tar.gz"
    version "2.0.03"
    sha256 "a2b851f125427bb711f093d0c5f66e604a3e3f0c56443029f85d67581730bb12"
  end

  # Fixes the Makefile to permit destination specification
  # https://github.com/kfogel/OneTime/pull/12
  patch do
    url "https://github.com/kfogel/OneTime/pull/12.diff"
    sha256 "9901ec7ed24b8db30f5d1a6fd40e1f882a0915f2d590830c554abed26369f8df"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "dd", "if=/dev/random", "of=pad_data.txt", "bs=1024", "count=1"
    (testpath+"input.txt").write "INPUT"
    system "#{bin}/onetime", "-e", "--pad=pad_data.txt", "--no-trace",
                             "--config=.", "input.txt"
    system "#{bin}/onetime", "-d", "--pad=pad_data.txt", "--no-trace",
                             "--config=.", "input.txt.onetime"
  end
end
