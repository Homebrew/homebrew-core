class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.2.tar.gz"
  sha256 "3258eca6b5caa5e98b67dd033f9eb1b0b7ecbdb7b0f07c111b704700962e64cc"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "3cd820e9f0ec6a3cc75302b4bf40528a7dc0412104cf93838121609872b806b8" => :high_sierra
    sha256 "d08bb4ae8f2d619d3350f0ba87430247ef593b9a47d8b982fbd36445831391cd" => :sierra
    sha256 "a8b1602ae833557331db2ff654801039336f7af098b5fd853ccf0d48796e3bf5" => :el_capitan
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
