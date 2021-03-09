class Archey < Formula
  desc "Graphical system information display for macOS"
  homepage "https://obihann.github.io/archey-osx/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/obihann/archey-osx.git"

  stable do
    url "https://github.com/obihann/archey-osx/archive/1.6.0.tar.gz"
    sha256 "0f0ffcf8c5f07610b98f0351dcb38bb8419001f40906d5dc4bfd28ef12dbd0f8"

    # Fix double percent sign in battery output
    patch do
      url "https://github.com/obihann/archey-osx/commit/cd125547d0936f066b64616553269bf647348e53.patch?full_index=1"
      sha256 "a8039ace9b282bcce7b63b2d5ef2a3faf19a9826c0eb92cccbea0ce723907fbf"
    end
  end

  bottle :unneeded

  deprecate! date: "2017-04-28", because: :repo_archived

  def install
    bin.install "bin/archey"
  end

  test do
    assert_match "Archey OS X 1", shell_output("#{bin}/archey --help")
  end
end
