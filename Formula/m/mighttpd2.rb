class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.8/mighttpd2-4.0.8.tar.gz"
  sha256 "cad7a92e3f9ce636d0099b226e080d0102a2498b9ef9d0abfc6b24e24f1d127b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c8f8195c36bbea691d3faf56681c1a9ec10932a550d9854342d41a78427c1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ea8b3e622834bff079b88311cb158ee882dd195136973eab5fdafdb0b798dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "594c27cc4bb9feec025e53492bd863f03a622beb0ed5efab87e0d35d3e02f129"
    sha256 cellar: :any_skip_relocation, sonoma:        "f614b9817495f3a71a5bd712bf6d72668e13f0ede9bc682e25c85eebb2372f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "04e1a56bce1760a82b6845e1ed2b864d984182d8015c3c641a32e6e3262f7d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "686df4669d80d3e379576984ffe0dfbe07197f286dc944045d7bab7ee6e26137"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system bin/"mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
