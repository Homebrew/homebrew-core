class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.8.2.tar.gz"
  sha256 "cf9bf0b2d92bc4671431e3fe1d1b0a0e5125f1a942cc4fdf7914b74f04efb835"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c26828d40b8047c753400ca89a9c4e7bcabd9787d18083322c8733e75245c298" => :mojave
    sha256 "f1babebdad95601bed4a699aabe15c5715e9221d9574da1dae4484ca45508f5d" => :high_sierra
    sha256 "746ea527c85fc00227967bdc6e02bdd8850fbd08404c5c60afe4ee5b24f68a6f" => :sierra
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
