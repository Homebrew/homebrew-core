class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.10.1.tar.gz"
  sha256 "bf10dc5cb084382384d69cc26b4f670a3eb0a97a6491182f4dcf540457f06c07"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "139db2c2c40cd4f316995f647d06c5bacdcd7758479b77e3f3a10975cb95244f" => :catalina
    sha256 "b002eb864da3b0ba027d9682d6c88a33c7b829fad7aa07749fe2552f94a0d326" => :mojave
    sha256 "03cd26d63744810c24303473239ba7ef22395477c15733d9aa0ec32315284a36" => :high_sierra
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
