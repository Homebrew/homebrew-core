class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.4.tar.gz"
  sha256 "c12a4931a5383a8a9e9eb006566af698e617b57a1f645a6cb132a321b671292d"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "751382abf7635800e882235dd51e5bb24dadaec680852bac762073f4647ed4fc" => :high_sierra
    sha256 "924b2bf01e97f3c6d05aeb245414eabefbdf24b6bf3c20a1b30f9ac9e8ec0a41" => :sierra
    sha256 "8aea171237392b624d565204abee77b2c7d8d6ad3d254c06124569ffcb742579" => :el_capitan
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
