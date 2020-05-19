class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.8.1.tar.gz"
  sha256 "bf6854e9aa352516436828a22628a4b7e17a8ed7c916e508a97b93b56212cd80"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea290f7e96ca2d9d538e8f77f28d9f07a987339de440034ec10f49ca578fe18" => :catalina
    sha256 "26023458b342bed6644cd74cbb0e0f96ecd0aec108d07a033b4455260ee42487" => :mojave
    sha256 "1af691eb2a1a0789a54ec66e8ae935ce6609076f59d94ba0993bee99cc3e5690" => :high_sierra
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
