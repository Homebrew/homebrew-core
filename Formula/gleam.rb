class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.8.0.tar.gz"
  sha256 "5b49b3121392550ce026fafb92c426a4435737002ebeed9c8326afa2750818a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6be27c1dbe887ad208ae364571f77bfd4e88852736c234b80bfbb940782c8b83" => :catalina
    sha256 "c2b88f19f2760c82bac1011bae752e735d9620dab1c1e5a6261316d9ba51a8c3" => :mojave
    sha256 "0323c247e1c57004ab34a92457061d11fb794ee7b67b5858d4f12939ced7194f" => :high_sierra
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
