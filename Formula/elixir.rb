class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.6.tar.gz"
  sha256 "74507b0646bf485ee3af0e7727e3fdab7123f1c5ecf2187a52a928ad60f93831"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "603448d76509eaa00f320b4fe1e6660b36ba78fd5a2e5f5ed453f97bfb4b7464" => :high_sierra
    sha256 "b48bf412fafa0260485bf56f6c2797a5ce1d86bdef0c1cb8444bd18e887384f2" => :sierra
    sha256 "10a572158f931c0a6037d91ec98e5b6342260cae885c7582ddf3e8b389744922" => :el_capitan
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
