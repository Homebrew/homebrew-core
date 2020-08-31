class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.11.1.tar.gz"
  sha256 "608209cdbc041e8a4fe5ca5b19c4f8002725b887f393f96b9d5cc0a01a44517c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d23945170c3fbce3d578962751bea00f7788d28fbbabb2785b9a3086d46f473" => :catalina
    sha256 "8ed93335fcdd5af4a02ab83ce8a818fae4edb527272416bd958fda001e49f6f1" => :mojave
    sha256 "18405aba9446b0dadf1248a1a1fbcce6a1a2b9a87948d39cff9aed7faf55737a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
