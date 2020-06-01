class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.9.0.tar.gz"
  sha256 "085ad8c055315bff592fedca3ce75635d25bf9298444fae75b0aea859ec2ad97"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f89b0eb0c0541e7c4b4b551a4651ec115aa365dc9cfa76172a25eb69313d75c" => :catalina
    sha256 "dc9b6bfb0b6d42224d096db9593f11e0608ecdb4e2d43bab8580aa47cd7cb0b0" => :mojave
    sha256 "c0164ca9bf1a34f950cdc2de052d5796a3966eed6baf249606e5e48bd9fa411d" => :high_sierra
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
