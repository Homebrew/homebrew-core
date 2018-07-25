class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.0.tar.gz"
  sha256 "791f726f7e3bb05a4620beb6191f2d758332ea7a169861b03580a16022c49a75"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "03338ebc23828982d3c820d3dcce3b1b3fc1500729b4fc4d4c8efc9e9aa59015" => :high_sierra
    sha256 "83894f92745ac1dbe5c318847306a022e6fa67739e79b7856c4b6f176044efac" => :sierra
    sha256 "ed6c4717320f5f200b43a760c343cd53a5f001cc8325c0c8b00708720bc663c9" => :el_capitan
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
