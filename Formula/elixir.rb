class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.10.2.tar.gz"
  sha256 "5adffcf4389aa82fcfbc84324ebbfa095fc657a0e15b2b055fc05184f96b2d50"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "604337af83d8bee4255560c47f9fbd62a0e0bf495185e1596774ad3efa09897d" => :catalina
    sha256 "155d3c7a1c4f3c08362362a4911726e2bdabd58382f7b7ae23fcf2e1f255ecbb" => :mojave
    sha256 "eb106b733719b9520a691f3b063b017ced8bd93bf71787476acab2feaebb6587" => :high_sierra
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
