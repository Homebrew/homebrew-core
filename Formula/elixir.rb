class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.3.tar.gz"
  sha256 "d961305e893f4fe1a177fa00233762c34598bc62ff88b32dcee8af27e36f0564"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a06541e028cdd23af796aacb0c4217828a4066eb9239f414250937dd7d7775e8" => :big_sur
    sha256 "dc94bf65bccb57f6794c8bb081faa5914cc7184a6ecf71c8ce904cb91331445a" => :arm64_big_sur
    sha256 "e0ff8e34210c0c1bc477b225b2cf3edfcafa82d2a1dcf071d1da49a51758003a" => :catalina
    sha256 "dfcaa759c90179c486044fbf04e6300b2c7588e9d5169fa050fafe618415dec3" => :mojave
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
