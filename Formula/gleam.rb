class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.4.2.tar.gz"
  sha256 "db1d9568138eddc56d5fc6135ae9f21b06335119fe7fe2526d6498a97fa4fd67"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b290e91df867d782be0ae2b892a65962b318f8b5a53ea76c828024222716359" => :catalina
    sha256 "09b9f26ac1d088926802f42a040bd54589e1be3805f68d1ace362550868c3944" => :mojave
    sha256 "ba13e23c4fe980c246b9fc579a5a51f0b3c59f21f7b02db167958751211ce3df" => :high_sierra
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
