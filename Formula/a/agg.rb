class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "8a4b81733085d81de1076e2964dedf729a8603941de11659d775478293d9efd0"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409d2ed8650b8ed3f280d0da256c3a22bb021091394ffc95df2156a527ce0a18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45fab29511d7718d19eff1094be56fa4ae45a0747e8447a485ceab933571b95d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb05c369fc8fb361ef817f4976ee38970c8cfdc8301235a740e1f02925729eff"
    sha256 cellar: :any_skip_relocation, ventura:        "c62d0cc1c2f1611e1c7fd170503ec4c9aea911ad51563b50438b0cedc0233bd4"
    sha256 cellar: :any_skip_relocation, monterey:       "1d40f111349bcb6f2911e6163c2cc50063ee7026825520597d1efb3a5518f7c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d135015e4172042b47ac1b9c4e184109f1d0d9bb98ce009f00f2028e62520cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541ce23ec266fea9c7fc3bd64d97e51112f999919ee9da2805c3cdaf33db39eb"
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
