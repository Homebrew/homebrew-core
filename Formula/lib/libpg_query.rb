class LibpgQuery < Formula
  desc "C library for accessing the PostgreSQL parser outside of the server environment"
  homepage "https://github.com/pganalyze/libpg_query"
  url "https://github.com/pganalyze/libpg_query/archive/refs/tags/17-6.1.0.tar.gz"
  version "17-6.1.0"
  sha256 "a3dc0e4084a23da35128d4e9809ff27241c29a44fde74ba40a378b33d2cdefe2"
  license all_of: ["BSD-3-Clause", "PostgreSQL"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "14f536ec31d48c53677d8f707d8a1a3629064126620071316f46c64651d676ca"
    sha256 cellar: :any,                 arm64_sequoia: "e8c80546510c8a0d0ee781bfcd508d628cb09f303027e740309b073b059659ce"
    sha256 cellar: :any,                 arm64_sonoma:  "62beb770cce1d083f1860515f7a4a553e403bfb23b37bb25581b1c61594da94b"
    sha256 cellar: :any,                 arm64_ventura: "44a8cf078ad22fdaa7da6047c51b50c86a23a48d6684b9c6ab65acbb8644f177"
    sha256 cellar: :any,                 sonoma:        "ef50a40781c354d2e287d203f19231c4939a2383124279358654f1ee8b7db72e"
    sha256 cellar: :any,                 ventura:       "6c5f8d26151c65de69c5993c8555494099fb51cb75cb65a4d1ec44736f7df6a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "495b2d5eccb24c22efee380c66c2f095f160398fbbd29778f0bc33a759f39680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb0b113d95c58f12d9a4f19a997f50ad2500970f44e592a801c4d756d7d9c31"
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/simple.c", testpath
    system ENV.cc, "simple.c", "-o", "test", "-L#{lib}", "-lpg_query"
    assert_match "stmts", shell_output("./test")
  end
end
