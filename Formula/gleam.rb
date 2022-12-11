class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.25.1.tar.gz"
  sha256 "87dd4d06bc2f511217efed92f9d271a450b6fc9ad74f0f286dc24df0f1b57659"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e24037806e7b583dd0df7b1d29da34b0999fc03e66247663ed819c468107bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "111c3263a3d5c525563b7449ca883a51b88ed5784d6c088ca5cd07e34b0f1561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0162521c29f0f7e5cc576c44b390fd3ba26ac238971ca9dff6a26224d0dc6b0"
    sha256 cellar: :any_skip_relocation, ventura:        "be672bde5dac80241a51972588ccda2983645dd968c54e1f6913883ba60344b9"
    sha256 cellar: :any_skip_relocation, monterey:       "40cdc4b59ea482d22516cd9de26c787116759db07a26cf90ed99ecba94703319"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf2677c71f0b43f6eec0da97b923e077e5b5a59054f62dc6f851e88003b39ff"
    sha256 cellar: :any_skip_relocation, catalina:       "89d38beb15062a7837935213074f710d7ec6d0cb5635df11105e89b11d34a7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "736eeae743f0afde7f623dd0075972fccbdb73d3ff6c68f83b5d3a2eaca792a7"
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
