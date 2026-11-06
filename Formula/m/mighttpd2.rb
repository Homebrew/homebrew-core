class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.12/mighttpd2-4.0.12.tar.gz"
  sha256 "958f4f097a889dd128d53951c9dd351f85a88ab8180c3d0be8811eb34060230b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b0d0e75877ffb3e1465da94b8f9c72541484cc2ab4552b4135a32552383db5b"
    sha256 cellar: :any, arm64_tahoe:       "b692e19ae6f1885dbee3e5f44309796d7bfbfbfc3f1944db350900ff682f67c4"
    sha256 cellar: :any, arm64_sequoia:     "9207c53381f154bcb2de9e77aa7e84df98f6cc1f014a003c399b4b6751a32c23"
    sha256 cellar: :any, arm64_linux:       "fe69e86f4065086ae71df1f877945321c69f0821107346564b561859b8a9279f"
    sha256 cellar: :any, x86_64_linux:      "1fd699f0de46a38aedf4441e092136e745e41d186331937ea46fe356206e36bc"
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
