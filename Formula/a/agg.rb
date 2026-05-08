class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "9a2a7e6ca2748befb6a4c1c3eff437ae6029fde99ec882a951b3671aa30eacdb"
  license "GPL-3.0-or-later"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84c24067c8f04b8377ae2e29dce6e818c24241d26a31a277977629418c571b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e85a17a983a8ff5cc779c7e9e81f455b74261b4ec2ec54a393a96d5cb9a7a32b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb981ebea9391bf39c0afd10bf04d09df4c6246b0c81e9b011b570edcbbbdf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "35591970b6a79e46ae2fb6eb69bf0c0fdae498b3b989f740d26e3bebf07cfabf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "567e32bc4493f562389d540c04da418c62aa545827ac61b685ec6cf3093b815b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54c17e64dea4c0cf93c4b7ca919498323da6a6a0a308c7b0b5242ade62f431c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\\u001b[1;31mHello \\u001b[32mWorld!\\u001b[0m\\n"]
      [1.001376, "o", "That was ok\\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_path_exists testpath/"test.gif"
  end
end
