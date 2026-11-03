class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.11/mighttpd2-4.0.11.tar.gz"
  sha256 "bf8cceeb34339c9357d489b133653c77e8f12a89350bed9e0873f6c1978ef6fc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf04edbfdba45430ff14877887c27bd53b0c1a72b18531710b091ed05a163657"
    sha256 cellar: :any, arm64_tahoe:       "4a9888eab361ad5dcf7c70cce6547da656404326e5123d19146a16565b42a3ec"
    sha256 cellar: :any, arm64_sequoia:     "86e9d0bdba78c1f82d2c19818fbe5148328288d4ca6f5a188acf98b56b260814"
    sha256 cellar: :any, arm64_linux:       "60afb6558d55144b701d4347c9feb40e36e192047608f1af8d2f36e720c722ab"
    sha256 cellar: :any, x86_64_linux:      "801c8c997298d157f48793b450594f70d0dcdcbe7c21908d42371f84579fd2f2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
  def cabal_args = ["--flags=tls", "--allow-newer=base,containers,template-haskell"]

  def fetch
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *cabal_args, *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *cabal_args, *std_cabal_v2_args
  end

  test do
    system bin/"mighty-mkindex"
    assert_predicate testpath/"index.html", :file?
  end
end
