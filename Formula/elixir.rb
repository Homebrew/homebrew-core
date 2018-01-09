class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.5.3.tar.gz"
  sha256 "0fc6024b6027d87af9609b416448fd65d8927e0d05fc02410b35f4b9b9eb9629"
  revision 1

  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "c57e32e9401ee3f724d532b9d8e53b0f5021da5b531dd309b28b7cdb0c4df768" => :high_sierra
    sha256 "6e74ae1e8761622c427b319ea182044f0108e1e4df40fe971e44ceecf4ec121e" => :sierra
    sha256 "f62dac3532cdaaa0f76285988362d5530e4f0cec73904d4da32782065b8eccce" => :el_capitan
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
