class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.56.tar.gz"
  sha256 "93943aee58f124cc21f70267fcfba48ec70a8dc112ddcba075afe074b51270bc"
  license any_of: ["GPL-1.0-or-later", "Artistic-1.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ed67bb9cd920c46a467874b497e9b74b273d49cbe42b43ca0a17bb0639e0453e"
    sha256 cellar: :any_skip_relocation, catalina: "0878f19ce28a67c6a9ef317e79bb1650b22047ff19afd863f3cdaa0a5a726967"
    sha256 cellar: :any_skip_relocation, mojave:   "806ef63d60125e9489079ccd72985cc484fd3f671a97b396ed00aad5166676b3"
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
    prefix.install Dir[prefix/"local/*"]

    bash_completion.install "completions/bash/feedgnuplot"
    zsh_completion.install "completions/zsh/_feedgnuplot"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
