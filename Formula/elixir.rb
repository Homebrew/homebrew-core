class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.0.tar.gz"
  sha256 "dbf4cb66634e22d60fe4aa162946c992257f700c7db123212e7e29d1c0b0c487"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f6f1bd16d0abcb975479277853884f50b24a6f3325307f3d271aebd1ca2f859" => :mojave
    sha256 "9c0a84cbcd4bdb4aaa827881d2682bc8891b6d24315004542aa7cc866cc24a9b" => :high_sierra
    sha256 "150281a49ee455287094c6c88f057b79e88748b7b0b313a89ea1dd771381132a" => :sierra
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
