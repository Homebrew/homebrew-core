class ChrubyFish < Formula
  desc "Thin wrapper around chruby to make it work with the Fish shell"
  homepage "https://github.com/JeanMertz/chruby-fish#readme"
  url "https://github.com/JeanMertz/chruby-fish/archive/v0.8.2.tar.gz"
  sha256 "e3726d39da219f5339f86302f7b5d7b62ca96570ddfcc3976595f1d62e3b34e1"
  head "https://github.com/JeanMertz/chruby-fish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e604e4c2114b462ff23291677a171e77284dccb7a3a0444f26dc293c01890f91" => :catalina
    sha256 "ba0ca145d65c92efa34f257219a96d94c4a82800ac5e37b71e3208ed61a82293" => :mojave
    sha256 "1ebd01df8a1edd51c2b73568c1db57b38a672b530fd0a55d063595370d0c301d" => :high_sierra
    sha256 "1ebd01df8a1edd51c2b73568c1db57b38a672b530fd0a55d063595370d0c301d" => :sierra
  end

  depends_on "chruby"
  depends_on "fish"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match /chruby-fish/, shell_output("fish -c '. #{share}/chruby/chruby.fish; chruby --version'")
  end
end
