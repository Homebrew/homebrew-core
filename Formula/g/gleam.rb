class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.31.0.tar.gz"
  sha256 "9b4e04887ff62007e19116939921397645c69d4f9b6c7b9de49fdb0a14260c0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7111327722a68ae69e2dc73cec94ba44826f74e13cd8e66fe5e12be7fcf94d4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e9893910046f149c3feb822e5912fcc7137b48141b69cf3579a97a28e256ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0db5f58e1676f9cdf357fa0181e839690c9d5d4d88a4adde39f9672cd13051"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9e8d73f0296bd42461f6ae28a01e63f3ecc77b4a974b80589392604e9f461ca"
    sha256 cellar: :any_skip_relocation, ventura:        "348753160e15ced74c355b2d9a125a624eb2ff567c66fdedff9e99a79cd05405"
    sha256 cellar: :any_skip_relocation, monterey:       "a4604b38729d0f0cf8d0762dd45eca7e8f96c404ad4c89c24749d24dec5616a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "607776b6459d7baed256b886d783636de7ca16eea647cea7758b693d2b6ff639"
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
    system bin/"gleam", "test"
  end
end
