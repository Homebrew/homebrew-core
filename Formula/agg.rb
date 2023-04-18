class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "ee997a9259b853d90aacdbae26ab64564022e1010d128b2713cc5ded16252e21"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7387f5582e328ef6f3f528985ffc749ae4b1dffc4666e5e936b2fce8816ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "497823e1548adb19a1cc94d3143ccb8d234046dbf1a86527fb69e9336b2f2030"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c52a0cfeb8cf3da6860dd75a746e14a0c75a9878c59d8c5fe09a3205fba75684"
    sha256 cellar: :any_skip_relocation, ventura:        "67585b60b87c74c20250c4f7474df5b99510d4f00ee17b5b6dac8b63abe414ec"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a87f95b856c04760a27ecfcd9cedcfd25c0da009e06f74347a6b9d34f8a3dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "653835cf332c262ab07cb12f9dfaf96f77738565230a70f5f4a0c6b4e7023b58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88ae35028c7081e39a13a4cbe77ecad2a674a4c7c17b1b7645e05de50ae91530"
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
