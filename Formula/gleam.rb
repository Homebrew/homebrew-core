class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.7.0.tar.gz"
  sha256 "7728138c249f4d20e866fab66076b7f677bebb7f292c8931faba3f1466689c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e0d20c20d8344b7795fac06a7009dd8912f419cac1eafb634e0065066a28eca" => :catalina
    sha256 "260839aa5c76bae333e8cf3772db973cc9f203afac3cbd5e97c8cd80372091a1" => :mojave
    sha256 "01a55348834c772ad9cd5b2c9b2a7a16c3986ded90130fae451ba58a6f71bde4" => :high_sierra
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
