class Map < Formula
  desc "Maps lines from stdin to commands"
  homepage "https://github.com/soveran/map"
  url "https://github.com/soveran/map/archive/0.1.1.tar.gz"
  sha256 "6903d2bb6d7e0cddceee487cc35b442e5e78a459785aa5ae7c84f13090f193f0"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_equal "foobar", shell_output("printf 'foo\nbar' | map f 'printf $f'")
  end
end
