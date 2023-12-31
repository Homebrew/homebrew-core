class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/refs/tags/v8.1.2.tar.gz"
  sha256 "1b705013a432e6ea90247f03e4cfeceb5a37f795d879178e4bf0085ce6191316"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d9998fa1119f6dbada06ff9e7a544ba62a0e55dd455f637beb5463c86ed8080"
    sha256 cellar: :any,                 arm64_ventura:  "620fc98eb3a8596902a0632b542940779bbed8225a9bf68e5dd9372d38f6cc8c"
    sha256 cellar: :any,                 arm64_monterey: "c1ede6c9dcc6b50b2d10b3d4f5e86dc51866be430c63ec606fa9128b1f212e03"
    sha256 cellar: :any,                 sonoma:         "1a60833abff334e0d92f43dfe74a5a4b3d745bf755d4335feb56d40305c1242e"
    sha256 cellar: :any,                 ventura:        "354598dcb310983dda7c625c91f2f9b532cd31a1f92b82071572abbae078dd59"
    sha256 cellar: :any,                 monterey:       "fcc050e01c4883a5c11197faf5ca543ed7af19be66ffb0dbfa0130d10467508f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "329810d6cd7634ba9d6ceb65dc15bcb8b6771f52862a6dd574b901cc963b6368"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.4" => :build
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
