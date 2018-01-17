class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.0.tar.gz"
  sha256 "28d93afac480a279b75c3e57ce53fb4c027217c8db55a19d364efe8ceccd1b40"
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
