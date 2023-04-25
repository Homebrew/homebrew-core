class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.8.0.tar.gz"
  sha256 "d5d7bdf60a77eb685b63b3f8fe01f3bc1c6f0d8b8fa36366de7412d535f9d52b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "459ef898fd0503e90a5bee0924ef134da2fecefffae741d6c4c99fa32e1411bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b83bb48c85f1af5a170f31630a8eae9f353930eb4bf447c0f0c58b717cbac5c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a98e7858e2067de97497ad4281f3d57c1c1d80f21e74f578e8f648b85d866559"
    sha256 cellar: :any_skip_relocation, ventura:        "6891ea92e3118a6b0e7a0926ff6978726bb9619aa95f5a368a57d8a2b8d36746"
    sha256 cellar: :any_skip_relocation, monterey:       "ec2a08080a5a1c9c1d532c72ca10e4aa562169f95d7d8e0d51625b75e3bbc471"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7a5f433433403ab803a5ef98c0bc51529a7b5b43d8c5b71d09fa3223ad3e9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a6d7c1b5eeb31e3e86363c3c1f266b8c7be1dbe5ce06f281584945afc92ecd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
