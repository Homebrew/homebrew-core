class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.22.0.tar.gz"
  sha256 "b5954cd128e22a5a26a95e33199c5f9cbffa6d5ee737b63193609f76a1dfb8e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ece49c3ffdce6abf179e7515b8ea01d12138d512945d6f73eef7e5ed3e63ef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db0de9a71a472cde15e27672f92c5e574bcba904462191a4561eb69020d3e223"
    sha256 cellar: :any_skip_relocation, monterey:       "1bc719f6b510c74dd1050282ce853e812508f7b7256eabf94a3ecba41e77ec2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "28a11bdb50b0f10faccddb160f8238a802ee0073c7fedc8fb7e749a4d7ce1f11"
    sha256 cellar: :any_skip_relocation, catalina:       "56f0626f1d481895fe99cd1d5235c292ea31b337fd35ccdd3eb726eab5bf71a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c3e3d79af459ba2840ec0e14f81927cddf6a3dc381b2aeec003d0a78e9da9fe"
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
