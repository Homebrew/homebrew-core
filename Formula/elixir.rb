class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.9.4.tar.gz"
  sha256 "f3465d8a8e386f3e74831bf9594ee39e6dfde6aa430fe9260844cfe46aa10139"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc27b1d278293c48c4ffaa8c845a1c0b3dffc346e3de3fcab5f38f0468d12a9c" => :catalina
    sha256 "b265e0fa289d4e0bdd6d3c5833804410094b0e92b50657b151dbad7ba0427ee7" => :mojave
    sha256 "53e9755a828a0f7f6cf5abcd3d72cb74cecd90ad1cccc552dcbd34b03e68ace8" => :high_sierra
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
