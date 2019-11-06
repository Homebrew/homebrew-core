class LibpokerEval < Formula
  desc "C library to evaluate poker hands"
  homepage "https://pokersource.sourceforge.io/"
  # http://download.gna.org/pokersource/sources/poker-eval-138.0.tar.gz is offline
  url "https://deb.debian.org/debian/pool/main/p/poker-eval/poker-eval_138.0.orig.tar.gz"
  sha256 "92659e4a90f6856ebd768bad942e9894bd70122dab56f3b23dd2c4c61bdbcf68"

  bottle do
    cellar :any
    rebuild 1
    sha256 "803f48db07d845ec9784792ed0fe5cdc86cb67e6632ed9f72dde75619481bf83" => :catalina
    sha256 "313ff85dd7ec513a95ee8846c657819fdadbebccf0bdce228f180305ee56a716" => :mojave
    sha256 "415934c921d4ccced5426f9aa807b0cf11da031cb2c973e17d506a9f740ac645" => :high_sierra
    sha256 "5216cd33d433fd9212ed14d6fffec593c7106226547c1555344604186e7aafc6" => :sierra
    sha256 "67b105600a8e29ed2d38421bc27340ff6e9092806f6458f0ddd6a27de0bcfb9c" => :el_capitan
    sha256 "b15086546ac1ac0310e3113231bfcc2c9de0d23474be8a1a1b4663e6bc8f713f" => :yosemite
    sha256 "9bbfb3886a4e530455dbf53581aecd0df8c86a2f80a444692441449c30f76d92" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
