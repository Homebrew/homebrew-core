class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "1b0648938dae88b17c80108a6df83768beb5f061c5bbb65edeafd169c799ea8c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f7341d96e56a7ba2fcdc7717dd5fb710a0b743a05bc63fe499826668532b78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c55cf0b72d33aad3c4854abe3dfb228bdffef342670fef8c6c07de5189e524f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f459a736f1a01d5225d528aab8e3a30b53f8826f3a5c3c8ad6bd1d0f8047cd37"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e22fcaf0e05743e0f0a2ee8f0e2e5d1bcb4821c9fe36550b958159da5c0c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "225d0cd68632de9564121418a1edd921199a4c63ba49c72eef93bf714fcb8f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b875455586b81bc412738ce232b03048779c29b94c1a944e3c56cc0041888c"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
