class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://github.com/DavidGriffith/frotz"
  url "https://github.com/DavidGriffith/frotz/archive/2.44.tar.gz"
  sha256 "dbb5eb3bc95275dcb984c4bdbaea58bc1f1b085b20092ce6e86d9f0bf3ba858f"

  head "https://github.com/DavidGriffith/frotz.git"

  bottle do
    cellar :any
    sha256 "2c48e1e411a9e6721a2f7bc493c0f2b25f1846cd7a74837ba48b70c2497025f8" => :yosemite
    sha256 "d51a6a6c16d0274843e0e1b629d73d5faa27ab8b7de713e5c42d6087c1391ec3" => :mavericks
    sha256 "d29b8dd2a5f92b818ad782d602764119fe8b211b853e3911cb0dbc0863541467" => :mountain_lion
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
