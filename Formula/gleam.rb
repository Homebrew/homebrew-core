class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.6.0.tar.gz"
  sha256 "6be0c908669917f448a59d2b0b66042ac027978da45e0b927b15cb914ba04d9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "97759a7b91eb786dcd0f3809482e757704085b37ed20b88538162ab980084884" => :catalina
    sha256 "c27989f152b25bd63dd6875af8d9c104679e0140451e7196054a6ae2ae236ee1" => :mojave
    sha256 "6050dd84d03228991ce741c275c2cd3ad3de2a189e11351d39269ccdb0bf5a3c" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
