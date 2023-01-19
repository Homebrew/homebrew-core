class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.26.0.tar.gz"
  sha256 "65654bbe285a41a637c71a5b3d1c828d9994de44e5543e720409d22e2c2e642a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21ac6f0b358d2db202557e21950f85cd3fb364bed4fb728157123eaef90607bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74ef9236221e70722aedc2f78f44c43f1aaf51e64a80bafb69f5b5d16835658b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7dae9d600644c51cac7dec8ea9e2f5b47e7c3308b9fd13b6803a00efcb0b048"
    sha256 cellar: :any_skip_relocation, ventura:        "00cb849435b93405f23b4f0d4109ebe61c67ff99db836e366ac6da6d297e6cb8"
    sha256 cellar: :any_skip_relocation, monterey:       "08c22f5fa9cf730476924f38108aabaa5ad75cc7fae1c8f780926566638af6bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c305c32b8b96f40418295c880df56c991bea5a78b026124a6f82ae6778e249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "990340eab9c854fa5a137458cee8d329a1edd2aad0cd6f104ef7b9cc09fc3b82"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
