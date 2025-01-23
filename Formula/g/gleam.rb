class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "e1a2081705b50c3a335424d6052e0aeb9dd85bca5daf6ab28a7ada7a0ba24841"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a4a69337c93716025873bcd8ac001702a19f74c3cd9160927e9aeca7da6a1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c54467d4b951e8901697b84d73f6c49fbf61914b3fd711c43d0ad891992b8e72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ea4121f6b0c058266eca96340eab9d3cf296fdaa81fe4258868aa841fb046ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "91e6070391567dd6f8f19e48ed89e7ed740741536e9401f1393ecc6c159bd77f"
    sha256 cellar: :any_skip_relocation, ventura:       "25737eb9b6972c2a44e3786b299acf1ca849ded5fce9f6f3dfd4e682355d643e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc3c2d3839ae56b5eeb3588ca58d70a5b6d28edb9c7cfb4dabcb122d6460533"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
