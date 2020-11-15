class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.12.1.tar.gz"
  sha256 "93797ef144f863120d305691913a21a3c42881c6cbc5a07bb2fe8336456e9aa8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6da58b7a1c1b8bae1206b1d27531bdad615ec56fc3b8b5929a62fd9e37ff40c3" => :catalina
    sha256 "9e15444a9598005a70e8c2834adfaf5735b02b98e746f06ae864a31875d690f3" => :mojave
    sha256 "718d9d3685d61c207c406857ce276d121e5ae63043e66a2ceb245aa3d131ed7c" => :high_sierra
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
