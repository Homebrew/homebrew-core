class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4bfbd0cc02f416ce868f0209b659a87e333de8f0b5edad19810e152ac6e7fc55"
  license "Apache-2.0"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8c244e06f37cc4b715320c197295f7be7d2883a15c71640df0459f6cb5e121"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c2f55063edd0c4de7ebc69aa0ff5e3885903aa361de0bc266512c72fc474a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75543a62f058deb8b394320b1230ed751b6b5fefa8460ff9ad3dd66a6cfe9b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "275a937214296eac98fe68e0201b94fae1a84c98cbc6cbd341abd16ad90a14ab"
    sha256 cellar: :any_skip_relocation, ventura:       "ba9d2505d3c305eba7b863b70d45439fd93371bb1175077a364e23f1f480cd5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc08101777ee80ab9b360d5beeb84a6f4c2f1f11b5b94e272288854cb8bc3546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0286d23d264406256b83e4cc63414ec5eb84e648354fedb9bc36922bc008b1e1"
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
    assert_path_exists testpath/"test.gif"
  end
end
