class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.0.tar.gz"
  sha256 "dbf4cb66634e22d60fe4aa162946c992257f700c7db123212e7e29d1c0b0c487"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "467fcbfb7c28e7b40adab41729b5733bc8f61fe5aa9fea389c008d3e036d1047" => :mojave
    sha256 "e22afbaaf607ed36f09c9781af6d2a0681500f6f1f8a28b9d30074640f2ee9cc" => :high_sierra
    sha256 "da201f12e4f419afb3c3a617eee2a07fc57ba349fd70f881ce1cf7f0a7ff5c63" => :sierra
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
