class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "541bdc7e7ec148d2146c8033e58a9046d9d3587671e8f375c9e606b5a24d3f82"
  license "GPL-3.0-or-later"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54472459b301a42bf49d001295aeef760c29a4187ec9813e4f426a7b00a7094b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a150d1be34c0799108913bf897761df69451c456b65f9db5eb7d87e2a0235890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9441c9fa8fcf93b8262fda19e8146444d9818838d62537fa56862de865877fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "836eff2ff4bf5b099774b7eec97e478fd88fcc0255076eef9160cab9c07bac68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac921a1053752e10c4583c2d41e9ad3070f718f6d811f40e93a9d5cfef56712e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61c1d9dbb81a4dada8e9075fada54d44baf596aa65ab716c639c07e9ca0be72"
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
