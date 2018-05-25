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
    sha256 "c03b80e4d5aa114b81ac04bfa77c46055fe01764ae877a8a061f3d43c9de8a72"
  end

  def install
    bin.install "bin/archey"
  end

  test do
    assert_match "Archey OS X 1", shell_output("#{bin}/archey --help")
  end
end
