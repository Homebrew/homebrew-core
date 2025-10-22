class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "8927e2f3b1db53feed2e74319497ddc8404ac7989cb592099c402fbd05d94aa4"
  license "GPL-3.0-or-later"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "111de71cf579f444632552967e802a4d2d2231783980257cb2074b6ea6c665aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e3d20e6feebfb8a7d3f6692b55fe9075a274e25371573506d1d0bd50b34854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a768f00a227e2a9dab8573d3092c5bb3b809ead87b2796ee585e96642ae32d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "79ed3722522e61c4463f4a1635814d71c1a4d5549712abfe0684bc8ba8b7be63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9d25a7264c451f75fe0183573f10c5419337eb81f86752c95e92c7cc9bc1d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6e1e1877a7a54519c6cd15626e091d7f58de72bb3fa8763b46e85ead83f9c7b"
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
