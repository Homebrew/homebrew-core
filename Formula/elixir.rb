class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.1.tar.gz"
  sha256 "91109a1774e9040fb10c1692c146c3e5a102e621e9c48196bfea7b828d54544c"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "ca594ec52c6410c3a02f78c702612e1d3650239e06f99efa5933d8cf9269002a" => :high_sierra
    sha256 "44c5fb9df692a6baee70aa2d1188d70fbaebdf0d308b5b49ec4ea972fdd689dd" => :sierra
    sha256 "ec77a04e7f9ac7035977b69035a64d2b92a4276ea5a208bca12fe13ed71bc668" => :el_capitan
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
