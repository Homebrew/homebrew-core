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
    sha256               arm64_tahoe:   "4bc9da87f0e44e511ab343cbffd2ea01efb8ac1dce27699af73c876ff93b4e20"
    sha256               arm64_sequoia: "d22074509e328133eb5511a075aa8e82a926494055aeb991e09aa5625994cfdc"
    sha256               arm64_sonoma:  "8adbebe724b806025453e8e8f782899a0b7565a0fdc25e87b8b307cf4634d446"
    sha256 cellar: :any, sonoma:        "a281980d8135d79077dc98048e17ab6b0f197d1e10a09081c9f3af2a8b8096e2"
    sha256               arm64_linux:   "1d6f4504698decff324a10b1b923a5af15a8a036625d0939bf312152ad5e1234"
    sha256               x86_64_linux:  "f7fdbc40fa2ff2a9cc86a55a4c7fb3bc35ee8af4ef7d33f52785bda641eea15c"
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
      s.gsub! '"-march=haswell"', "\"-march=#{ENV.effective_arch}\"" if Hardware::CPU.intel? && build.bottle?
    end

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    (buildpath/"cabal.project.local").write "allow-newer: base, containers, template-haskell\n"

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
