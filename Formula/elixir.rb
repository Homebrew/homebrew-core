class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.0.tar.gz"
  sha256 "28d93afac480a279b75c3e57ce53fb4c027217c8db55a19d364efe8ceccd1b40"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "2674d6347ddad33a77771264e49f91e3dd7b49b64ea8bac5cde11476a352c7e0" => :high_sierra
    sha256 "fcb95bb5b7415303c272da91e4a369233c4cb466f6af16eb1e6a5396ee3e7111" => :sierra
    sha256 "8d3380a735359b041d72fa5a2f2d6125b059601a4a50bdb7ff8b73256eb601d2" => :el_capitan
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
