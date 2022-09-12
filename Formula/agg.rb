class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "51cb553f9adde28f85e5e945c0013679c545820c4c023fefb9e74b765549e709"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86d0f583217bc42f5dd763a5524d4efd97efcd62f3c3f97d490e02b5b3bc8559"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bbb4aef066cba5f8604fd43eec2d2f919af821ff4a307f26a9f1f318e22bad1"
    sha256 cellar: :any_skip_relocation, monterey:       "ce77e82ba4972a7d374cf76c5e4828639219a68b8d9934b0c1312d6cae08f324"
    sha256 cellar: :any_skip_relocation, big_sur:        "9027e18f85fbbc7108f0180c6a2d94d4b25b76c446f62b803468f65b52d05f00"
    sha256 cellar: :any_skip_relocation, catalina:       "27535b67d985f55670dacef2d91c1bcfed474cd4610d4265201de5c1b39a67c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "801e65d0bd501a6fa8815debeedd36730127de5006f04e5d333e3d49d6182a9b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\u001b[1;31mHello \u001b[32mWorld!\u001b[0m\n"]
      [1.001376, "o", "That was ok\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_predicate testpath/"test.gif", :exist?
  end
end
