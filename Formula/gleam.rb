class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.28.3.tar.gz"
  sha256 "e9c6b7400a21d0d29db59b0c5b6adc8cec492184461f778f3b36bc989f1226da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1704dbeedf682279c38ffb3b4494f8e40ab2c50476bafa0cade46417283ea655"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5b72f9d00997b1f3f16e06c0945424cd9534aa8f67409ae612b159ae07a4bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "868591fdf77dacb1ef9d836efb1605176f6dbc343bb476b670ae9849226fb74e"
    sha256 cellar: :any_skip_relocation, ventura:        "05a0281bea62fcc8de3c2f0735cb54b909efef3b06d5aead9f95c6396cecd243"
    sha256 cellar: :any_skip_relocation, monterey:       "3e8a4ac593e438c952b5339babc43d50cb5b08a9d7d4ce30f9a84eb449d631cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "eec7b252ee98b71f111b9d1d9e518bc073426aee0aa871052700b061fc8a2e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31652a8910b076e9f35e5cabd2ff4fad8905f657f5e759dc9943204e20741234"
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
