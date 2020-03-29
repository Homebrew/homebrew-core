class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-2.9.tar.gz"
  sha256 "09314fe7d7ba2c26fb02864b9ddc92a538bc53674200363e77bb53a2fc1c17be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bd7129fa7c2635627e6c78b0dd96e9fe7f51fcb58fcaaefc1a8f549275275173" => :catalina
    sha256 "fbd15290717e762090d699ea2ca7ed649124b4fbcb702bc5873ab629dd00f0af" => :mojave
    sha256 "875913b4e09b30348a651db65afa6049ed659aec192f32b8564f465fcaf5bfaf" => :high_sierra
  end

  depends_on "postgresql"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    return if ENV["CI"]

    system "#{bin}/pg_tmp", "selftest"
  end
end
