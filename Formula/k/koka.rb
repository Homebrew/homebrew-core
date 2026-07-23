class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
      tag:      "v3.2.3",
      revision: "49dede749f9eb77c717077c00fe52039b3183b5f"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "ac681e7d05be5109301c9bd812815b11a8d6beb1c5ad65274d48474434e405da"
    sha256               arm64_sequoia: "90dca4c22af849291f5a9bdb2eb0d21d9c6ffc5d04e705455e072b40554b7732"
    sha256               arm64_sonoma:  "b11d6bcbb28be3e1ca6a5d658e1b52b23fc63c9850d84f492effbb1feaaad68c"
    sha256 cellar: :any, sonoma:        "633e429728e628ee7b0e38507eb466e115265b530e1b6ecf5ac1530a4f03b879"
    sha256               arm64_linux:   "2b85809ace4fcc5d9e1da834596344343fadc7e31c0b8ef102772c88aa12003d"
    sha256               x86_64_linux:  "56a4d9e65b26cd246e51ae2bee021c1d15444dae237b5a1bfa5690870bef499d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "src/Compile/Options.hs" do |s|
      s.gsub! '["/usr/local/lib"', "[\"#{HOMEBREW_PREFIX}/lib\""
      s.gsub! '"-march=haswell"', "\"-march=#{ENV.effective_arch}\"" if Hardware::CPU.intel?
    end

    system "cabal", "v2-update"
    system "cabal", "v2-build", *std_cabal_v2_args.reject { |s| s["install"] }
    system "cabal", "v2-run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=#{prefix}", "--install", "--system-ghc"
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end
