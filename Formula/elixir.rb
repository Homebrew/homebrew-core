class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.1.tar.gz"
  sha256 "94daa716abbd4493405fb2032514195077ac7bc73dc2999922f13c7d8ea58777"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0653df1147c419a95501e9150dced476455ea346e16e929610462a55f0588459" => :mojave
    sha256 "0b7621209b77bfc665227fe434853d2cc70dfc852a9aaed485e382d70e8ff52a" => :high_sierra
    sha256 "7c2eeb5ef4932424d20bd549c3beb597fa5121116683e5f40880dcb43391d726" => :sierra
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
