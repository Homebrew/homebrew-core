class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v8.1.1.tar.gz"
  sha256 "de11b252c5a917909a0eac473843368655efc0f3cea30beea2aedeec3069d54e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "93f887e08efc1981beb927f391a2be65c9aa8380eeb80fe9a5cfd75b05ef59ea"
    sha256 cellar: :any,                 arm64_monterey: "9257f041705005e81ffd63fec2e8edc730ab8b2f662889ac9523b89e4a1b9716"
    sha256 cellar: :any,                 arm64_big_sur:  "691633a52320e1f45875b0ab0df23aa2f1a87c19c7edfc95ced329741e57b415"
    sha256 cellar: :any,                 ventura:        "6b0e43b21ead41d1c5d87f0d09f447b48fb94d19cfad4ff4ec382e2ba85ba830"
    sha256 cellar: :any,                 monterey:       "cc87c5b7b93a85f9a29ef23b5653ab6d1588524468713af2edc01c7bf44394c0"
    sha256 cellar: :any,                 big_sur:        "bd4e5c0f86ad0b43a087b9c17f6f27f5a94ee05dd7fc16224f29cecc60710dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "360d385500fe363dac30ad73eb4618e50ccbf70923d6cceb0d7c508bcdd15edb"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
