class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.1.tar.gz"
  sha256 "527af54775401cc5074ea698b9b6a6d67c5103056d2949638c101bc6f233e954"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "58ba0f22e50013f03e544d501d6c953f9991ba4062e7d21cacdf47ec73e6477c" => :high_sierra
    sha256 "86c83515e27674c637b16598ea779de6edcf01cc799bd1a797dc819424454fe8" => :sierra
    sha256 "0136627361b7e0926a9d642e15f7350d449f8d9568fd844b666153604488bd07" => :el_capitan
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
