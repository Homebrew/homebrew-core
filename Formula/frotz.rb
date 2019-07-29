class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://github.com/DavidGriffith/frotz"
  url "https://github.com/DavidGriffith/frotz/archive/2.44.tar.gz"
  sha256 "dbb5eb3bc95275dcb984c4bdbaea58bc1f1b085b20092ce6e86d9f0bf3ba858f"
  head "https://github.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "bd7d173c661883a5ad370c4f2437dfcda10e2852988e4a1b0b681ee19335ed97" => :mojave
    sha256 "f1be9afe41e33396475d99511760690d3a46f9362fb2229e42ba48146d92f8f0" => :high_sierra
    sha256 "e190264a540f03ec98b7be45d1edfc73c0bd4946b4d2c4aacdf98521354e4ca0" => :sierra
    sha256 "6506ec53859a859eb71ab33511a11e9c957e0749cb25efa06d63d6c80d000b4a" => :el_capitan
    sha256 "887efd67a050038ffb15df8c713eaa40fcbfcc69d36f58373981dba3ccae422b" => :yosemite
  end

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! %w[CC OPTS]
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "CONFIG_DIR", etc
      s.change_make_var! "MAN_PREFIX", share
    end

    system "make", "frotz"
    system "make", "install"
  end
end
