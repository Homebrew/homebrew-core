class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.27.0.tar.gz"
  sha256 "e62bc5976439a17c4c827fa9a25a84c36d08fff1396bbf916ef5219664c17e81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "473b6e3ba7245c5e149adb6640e03a804972c4e36688af05ce04cb415f3d1ad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5f3a3cf65d09d1666f85e9fc347b5763c57dd610cf19f64af595e6ccbf3abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21d2679be876685828d35985c95ca2d140d5f1e49df7e948ed1f4ae225b9e5b6"
    sha256 cellar: :any_skip_relocation, ventura:        "2a2004587bc6678e7275899a321d2c80098552a896c64a69bf2df656017a54d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b33054007c6de79cf8352a5e1be5c95665ab4da0167132e29bc0c57556c8c58a"
    sha256 cellar: :any_skip_relocation, big_sur:        "14257a4f937c6a21190ffe4258216e9b341972e7d1bb5a0b64d656f36188b5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414908d818486e1659e500018f26858808b2e5c4f771e9cd6532648ab81193e2"
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
