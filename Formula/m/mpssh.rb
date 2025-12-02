class Mpssh < Formula
  desc "Mass parallel ssh"
  homepage "https://github.com/ndenev/mpssh"
  license "BSD-3-Clause"
  head "https://github.com/ndenev/mpssh.git", branch: "master"

  stable do
    url "https://github.com/ndenev/mpssh/archive/refs/tags/1.3.3.tar.gz"
    sha256 "510e11c3e177a31c1052c8b4ec06357c147648c86411ac3ed4ac814d0d927f2f"
    patch do
      # don't install binaries as root (upstream commit)
      url "https://github.com/ndenev/mpssh/commit/3cbb868b6fdf8dff9ab86868510c0455ad1ec1b3.patch?full_index=1"
      sha256 "a6c596c87a4945e6a77b779fcc42867033dbfd95e27ede492e8b841738a67316"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5dfa9aa8dc66a51ca4c7639f036b59c2b587cfc907d47b400fb03e7df982a64e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6b6d83538348cb97b5847fcbff26efc651cf313bc6ce8c4c572d08cf3b43deca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f4e641ecad2e8254a0833ffa46e5168ad2985d0e7ff50fa1b193cd4eec90877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "124dbceb59eb36d94e15247ed771965c724b84bce47090523e74021ac4336a8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcef6cadd8e60b9856c5cc99d1047deaee4a18a852127c0e4f22fb59f9751371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d5c61b0953345267eda6e05e0c712823ecf4d037e2960ebcd4d836c045ef4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9be22691fa0cd36dcc70ebf92e7d8ed2fecbe493f6cdfd676284390b85f4b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "3a90eeb34d282fa97d59a7084972b98bac3c94333b81e264110e9fcd6e894476"
    sha256 cellar: :any_skip_relocation, monterey:       "94d6b1821f850cb852373d0e46b9da787b799d726f4917ece31a0e0dc149b25a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6e032b03f612d0be60c38b1af6688f8786e9c097d52c2e8bd3cd507290e4482"
    sha256 cellar: :any_skip_relocation, catalina:       "714e7b0e97a942f68885baefa599d97e143631154480d0246d04e21a49910acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e8e905d29e7029da56deb5d87820165715519f27deb1675446434a51b049a70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eabc527317cd3a5091e6efabe168b926693d6eb64644fec082a251a99725669"
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "BIN=#{bin}"
    man1.install "mpssh.1"
  end

  test do
    system bin/"mpssh"
  end
end
