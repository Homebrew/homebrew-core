class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.2.tar.gz"
  sha256 "02aaa3ffd21f9cf51aceb3aa5a5bc2c1e2636b1611867e44f19693dcf856e25c"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01597b9d2b58a8ba7edfe43bc5aa4ec2ddbaf4f92eb2bceeafac0c968c8e9e22" => :catalina
    sha256 "6405614eb216272c112b76a98ee1018e691047113fc5f67b93aa29bf93302ee7" => :mojave
    sha256 "9744bdeac82883b1619770795ece3ca3b57b0b20a0545f11b4935e13e205afc2" => :high_sierra
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
