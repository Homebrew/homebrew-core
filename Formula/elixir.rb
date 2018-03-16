class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.6.4.tar.gz"
  sha256 "c12a4931a5383a8a9e9eb006566af698e617b57a1f645a6cb132a321b671292d"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "143792ff168495e7068981b7f57a72eb035760dd1397584221fb4bf0ad026d4c" => :high_sierra
    sha256 "cd74ddeb1a77422ebb7a3ffc6c702bb4e86dfda22c00dd4dd0a30f1343c13d5c" => :sierra
    sha256 "eb82080478d423e6a8c11b3e65270aa688b7adaf1a757cb16103b3dcaf72eb23" => :el_capitan
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
