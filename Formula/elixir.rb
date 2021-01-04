class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.3.tar.gz"
  sha256 "d961305e893f4fe1a177fa00233762c34598bc62ff88b32dcee8af27e36f0564"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b7654b37bdb51dfd52e4b794153f305fa1b847e29d0d02427325e8e8cd1fb1a" => :big_sur
    sha256 "e10203444858ca74fadbcf6383c2c3aaf866ff44a9c6337ad82769953c269dc1" => :arm64_big_sur
    sha256 "44de459466702ce2534b211cf19bb0855a4af2ee7cc8b472574137fc8c1dcd0d" => :catalina
    sha256 "72c8d551c7a3c884b5be801fd64b03ea0d6ec00da8a7fd8dec2fbccb29afdf45" => :mojave
    sha256 "81ef2b9d5b6de22ef96175761afa61809eafc94719d3a67df85ef074217380a5" => :high_sierra
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
