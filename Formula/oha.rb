class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.5.tar.gz"
  sha256 "13ade6a14efefb266907575512ca88b6ea1a37ab8d4060d638f26c3bcee17d5f"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "361edb589ffb66a5bee902058a9235aa027fee879e09c9c40930d2d031406cb1"
    sha256 cellar: :any_skip_relocation, big_sur:       "617eb0c53703a471e8d542367560a2aa37c54baf4051301b9a0a133030918978"
    sha256 cellar: :any_skip_relocation, catalina:      "4566468439bb76337d1f022548c09aaaf37806860583144892255a6466104bdf"
    sha256 cellar: :any_skip_relocation, mojave:        "4ec5b61c8842d892b4712185922e09824eab582ff6e2f6a1ae44fec01f721160"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
