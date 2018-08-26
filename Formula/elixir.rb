class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.7.3.tar.gz"
  sha256 "c9beabd05e820ee83a56610cf2af3f34acf3b445c8fabdbe98894c886d2aa28e"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 "a18bd321e556d0e78e4f6fc3817ba9cef140bd9414e8cf1795cfa1a833c11a30" => :mojave
    sha256 "6cee1b802da76cc0540e9bfd2667f2ce156efa78a8c72cfd0c68250a4ee70d7c" => :high_sierra
    sha256 "e43ad34dc7e4b38fc71e7dc119d19e67c945ec5e60593ec4d3014fd3809bc3b7" => :sierra
    sha256 "0010ce46f5c3e1b125e0614e71eaa4bc61fd0b470bd1b687cb008112577cef1f" => :el_capitan
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
