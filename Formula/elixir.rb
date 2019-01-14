class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.8.0.tar.gz"
  sha256 "fe896d8b2914f982d2e6fceeb585f59a8f92ad872653fc46c13df9ff86d69234"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "bf12a711bafb1376ef61747a8b630f3dc17db104a2067ce2d7681db4e84b7dc9" => :mojave
    sha256 "571a686fc769e8c6d83040d8eba361b888842a3f9699284e9585e1c76c15352a" => :high_sierra
    sha256 "481aefb8f5dd96e32bf38bba04019f4951c2b62cc16293ec98d329844e7c62f0" => :sierra
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
