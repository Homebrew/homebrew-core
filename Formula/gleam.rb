class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.4.1.tar.gz"
  sha256 "6093215519ce175449a4923ce2354bfe874f4e8367a93afb2176d896e7dbab96"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf108d3964853578b938f66e3947d053067aaa8d894e30d2e65c6299559b9700" => :catalina
    sha256 "84f6f339db95531277c8109ef3114b47fbdfc86b789a2802037049dbd748f913" => :mojave
    sha256 "da064bb1ba9c17e2ff45ecf529d96ab7375e69f05b524cb470a633e69b8f2779" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", "--root", prefix, "--path", "gleam"
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
