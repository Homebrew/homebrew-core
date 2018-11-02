class LSmash < Formula
  desc "Tool for working with MP4 files"
  homepage "https://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git",
      :shallow  => false,
      :tag      => "v2.9.1",
      :revision => "4cea08d264933634db5bc06da9d8d88fb5ddae07"
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha256 "811e696583af5a78ec288d46f8815d5a5db246f335d2ba2e0d4f3fce9a98e2a2" => :mojave
    sha256 "eae1dfce4f50c3b48d2a3fabf415ad7ec98de0937d610fec98d700e517e18934" => :high_sierra
    sha256 "57802892865529a99658bd4da1b29eb5287259183658131cc215ef80fcd0cfbe" => :sierra
    sha256 "5751796e42e7d544f4976bc304a0ae7407dc5217b2b4218b0a6afdc18ea3eeaf" => :el_capitan
    sha256 "3703bdeb1dfe66aef898e60a990f4e64f0ab3c1fe26a49cf824b3c6998acaacc" => :yosemite
    sha256 "78c5c52a90e1609694b43a45240126515f97be8a1d129a57215d4a7ba9e3717f" => :mavericks
    sha256 "5e2cd2ae65a0aeb7d1429f18fbd41dd7bdbfc03fcd10f320e41fc0cf6c95aef4" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    system bin/"boxdumper", "-v"
    system bin/"muxer", "-v"
    system bin/"remuxer", "-v"
    system bin/"timelineeditor", "-v"
  end
end
