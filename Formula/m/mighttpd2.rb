class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.5/mighttpd2-4.0.5.tar.gz"
  sha256 "3b8db69586cea76adfd6b17d2988c99153d184e2eec05afdae0686e19468237e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d248a47bb1fa4501987a58f7f689979e58cde43e4893d0007ebfe29e007c4aa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f0716eac79532a66266f5eacb9489065dbfd1f387c066903b51b7f89efa25cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0adfdaa1f5131840a89d04967613978981d44e0829ce0932cebe6e31b72f3c48"
    sha256 cellar: :any_skip_relocation, sonoma:         "e51eeae602afd0466c761fe96c1966eecb45da4d689f87b9184d67fe2c24742f"
    sha256 cellar: :any_skip_relocation, ventura:        "c0468a31654b0799032a97fd8168c57aa9d66ae60c89d1365d3507dcd050a202"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf3e6a27d07f21ea80c639effc7cd81f3adf54df755ad16940d7a41b7f427bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f1994ac8ce022160c0c3282714bf15e2e4d16d02adcb61cac962604f66e00b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}/mighty-mkindex"
    assert (testpath/"index.html").file?
  end
end
