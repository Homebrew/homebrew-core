class Archey < Formula
  desc "Graphical system information display for macOS"
  homepage "https://obihann.github.io/archey-osx/"
  url "https://github.com/obihann/archey-osx/archive/1.6.0.tar.gz"
  sha256 "0f0ffcf8c5f07610b98f0351dcb38bb8419001f40906d5dc4bfd28ef12dbd0f8"
  revision 1
  head "https://github.com/obihann/archey-osx.git"

  bottle :unneeded

  # Fix double percent sign in battery output, remove in next release
  patch do
    url "https://github.com/obihann/archey-osx/commit/cd125547d0936f066b64616553269bf647348e53.diff?full_index=1"
    sha256 "2d5abe6d0b34cf94f3511cdd43f883a6f448942bd36684739100bdadf1e66c0c"
  end

  def install
    bin.install "bin/archey"
  end

  test do
    assert_match "Archey OS X 1", shell_output("#{bin}/archey --help")
  end
end
