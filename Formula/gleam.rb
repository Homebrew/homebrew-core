class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.7.0.tar.gz"
  sha256 "7728138c249f4d20e866fab66076b7f677bebb7f292c8931faba3f1466689c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "4007318d7fa80ed183f5c5ebdf3ac67e4254fe6699380640b4489257e2526530" => :catalina
    sha256 "f7d4dcfa53e3b599e87712bb5c1bedfebf68f1d0e24811ad7a23e027e1259947" => :mojave
    sha256 "ba8f452d9dd121cb3675c944ea94df5b249efbceba59fd3ac4e521437b8194c3" => :high_sierra
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
