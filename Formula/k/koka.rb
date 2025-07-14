class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
    tag:      "v3.1.3",
    revision: "acce6267bf0c35da37610a70b7ecf9d3c7fc4b94"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "dev"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256               arm64_sequoia: "40be28f80d005df22bc03410fdb5be5d16d54d80e4ce3cb28411ff165a4e6161"
    sha256               arm64_sonoma:  "727c9ff5fcac5429d5916a5637eb4b2d5966824ebfa35a9d35ab043fc160841e"
    sha256               arm64_ventura: "f6ac8e720d0589989cd2235543977dd7c159b8cf0a9770378703ec659afd3fbe"
    sha256 cellar: :any, sonoma:        "652825acfb5b84436a91d87874680f45c3395771c913a650120efa84d323dcee"
    sha256 cellar: :any, ventura:       "9299ff495073b003e0687cde8415281f0df9bae3bd3ce0f1a6163274b586a559"
    sha256               x86_64_linux:  "0a929e297f31139aa87d737d63ca7e439a4962915b885b31b57703265733c041"
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
