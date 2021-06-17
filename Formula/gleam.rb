class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.16.0.tar.gz"
  sha256 "9259e46f356e5d5a419c2fe21be9c359bcf2023260716760c738a011881bff7c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cdbf1b4809625a64c95c36b876088398c77e9d60ffed0fa68c01b04f9438d337"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f9a345992d50f46dbab9497b7a1cf86ef5be14d1f721eac53f7a39a4e157f95"
    sha256 cellar: :any_skip_relocation, catalina:      "548b4999e2148327b3207e4346c728bb7c4158b76a55f5ecb59ba5b89988be60"
    sha256 cellar: :any_skip_relocation, mojave:        "8e8cfaf5a46615dfac675505f2a496c193e5dd04e9e3bcea1141617546b0d470"
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
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
