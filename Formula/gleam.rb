class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.5.0.tar.gz"
  sha256 "ee65ec241fa604b7fce97a7de8ea2d193e41dab8e7115fab759b6b71247025f4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8554c7e81378dca051827e5a10b46594b210c035b947d367256a7bda8d8c2d31" => :catalina
    sha256 "594bbaf47f4a260a24a16fc7f2cc34f4889a071f96eb89b6d1d36bdf4ed1086c" => :mojave
    sha256 "f46e3c4fb0a5162273ba1d87c623c4c53f9284254200442b005061d4c165cfbb" => :high_sierra
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
