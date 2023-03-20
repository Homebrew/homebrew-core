class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.2.tar.gz"
  sha256 "e28836e23001b79cd2d2e9e0174de426be46388e28b7086c57d3d072481af9b8"
  # license ref, https://github.com/jonmacs/jove/blob/4_17/LICENSE
  license :cannot_represent

  bottle do
    sha256 arm64_ventura:  "7af101ff7a427a8a1a58d1c9e8515152762d7fe7b10cbb6771993e14d56a1416"
    sha256 arm64_monterey: "a50812450aa1df1b30a9ac10366cd6df2809eda1fa28b032f2c7577e5b1e0880"
    sha256 arm64_big_sur:  "db4e65e875070304bae62a626f8bc060132e2e535ba986278f8cd6f7119075c8"
    sha256 ventura:        "c70d60697b11d1b96123501cff0cd0d065f5ed4cc76d6848505269f83caec5d0"
    sha256 monterey:       "590d4299234d44e636d0a2a9a82ab13b8cd484a7724cc095bee4157f71ee19a1"
    sha256 big_sur:        "542c5d88054fbb06fd38b47a7b642e9c2efb32dbfa94e4184fba4763e94d2aab"
    sha256 x86_64_linux:   "8e26043308d1cbbf92b8b554ce5e4accbc25b3f347777e60e8e37e447d02b825"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "DMANDIR=#{man1}"
  end

  test do
    assert_match "There's nothing to recover.", shell_output("#{lib}/jove/recover")
  end
end
