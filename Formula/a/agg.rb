class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://docs.asciinema.org/manual/agg/"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "8170119502ad2c1c697e5cd4d050d87c425ecee726c5f6c3c2140703bcb31bb3"
  license "GPL-3.0-or-later"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71fb09352822444512d353cf99123168ff60f6faf313cde7de536eff35b167d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c291fdadf2879fa842c38fe7542fd6c0d217ab8073171ec00c8ee61331515ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9654cafd1dd5c9ec31fd5a88238d37ed15329a9c17b231023164fe7cdcb8d5ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf1c490d4e4868923ca57e97b9399f88f17660c78a529781f89d6a3617c76f3c"
    sha256 cellar: :any,                 arm64_linux:   "774515c24c73c13d3b43f51741c0eb909fc89ce517a41d97ce8dfb6211f7c147"
    sha256 cellar: :any,                 x86_64_linux:  "b6049f4fad97d2d198709c7426b57f27d8ec4cd242a45ab4a8d2c0b0e4110d89"
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
