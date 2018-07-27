class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.1.tar.gz"
  sha256 "527af54775401cc5074ea698b9b6a6d67c5103056d2949638c101bc6f233e954"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "64efa368cc603413a91726be350b4b4d835ca48514c889fe2728868a5da008db" => :high_sierra
    sha256 "eab80418b4bc8afde59e43d4323b882e362525ab79c45ba592238882c4bea3bc" => :sierra
    sha256 "0cddf7beb7603bb840b83d26019840e55bc435007e8da7ace8c42b3b868962f5" => :el_capitan
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
