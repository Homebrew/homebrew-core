class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
      tag:      "v3.2.9",
      revision: "facb7932ce6871fdb063f762a304bd8238f35fba"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "eb1e4b165a587a815b45f8127b6b8c25142dcfd94adce794d6fd5dcd81b7d877"
    sha256 arm64_tahoe:       "6ac7623df6083e39385639ee53511a4bc3c946110e527f4b863bf8dcaeb1161a"
    sha256 arm64_sequoia:     "b3127a13564e8669f177aaa012b3619c983c6a08ba1671f67d1f163e1ffd0c78"
    sha256 arm64_linux:       "fbaae82d33b0cf0f7dcc3744c96ab85f9501a4ac3315798d39deec6b77258234"
    sha256 x86_64_linux:      "68d8f40230ed594f2fa530eab0a4e860e9eec302fd1b8bdfcb2a67c6b21bbbf8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build
  depends_on "gmp"
  depends_on "libuv"

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
    system "cabal", "v2-build", *std_cabal_v2_args(installdir: false)
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
