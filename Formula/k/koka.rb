class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
    tag:      "v3.2.2",
    revision: "39b4bec7327dbbcb2f83ce7aca5fe061931a4dc3"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "3216d60ef3db587b508fb72139ee29d9c50f0f58d59b2a2f6ee87171ecedc478"
    sha256               arm64_sequoia: "b232e8756d3e827d6ff5d20df38ead3c116ccd6114b994323696c168604776f5"
    sha256               arm64_sonoma:  "59e8dc38bbf66bc259afa45b837aa70fde60f9a106c2b3895ef14b0c876b0b6d"
    sha256               arm64_ventura: "aed65125db396062d0e25a4f612d89bc02b46d9d61950d458282900384f5ef1e"
    sha256 cellar: :any, sonoma:        "75f8a3a7d09b70e31aaa7b299f6c9709f2130d72d80ef217e933ee9e628b460c"
    sha256 cellar: :any, ventura:       "de168feec52ce04ecd56049b4ef10f9911aa46c64f8d533d9e74c564c76a8c3d"
    sha256               arm64_linux:   "2e53a1cfb65f0d5cc89c8000195e769daf8ce935839caffc9cb9f4e923a6ab45"
    sha256               x86_64_linux:  "ed3665df8c182f4b9268319879a21d49cbf4853bc2cb8d3171397a5f3ddba412"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    inreplace "src/Compile/Options.hs" do |s|
      s.gsub! '["/usr/local/lib"', "[\"#{HOMEBREW_PREFIX}/lib\""
      s.gsub! '"-march=haswell"', "\"-march=#{ENV.effective_arch}\"" if Hardware::CPU.intel? && build.bottle?
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
