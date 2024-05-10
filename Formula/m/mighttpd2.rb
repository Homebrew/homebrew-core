class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.6/mighttpd2-4.0.6.tar.gz"
  sha256 "13187245ed081893f4a2bf921cb0e00e401ca0ad29223f33929a6bcab3993eee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a43404c9e2edc17c9fd889f8be1d2c5a194a950a9ecd60f99ccc8816bd691e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "283297cf61c3d38f84f040214bbd9487b7e3814bc44a974be9b9d7ddd954c64a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46d398fcb0200b423e2fa911bcf476987bbd548f74b00bff9bb9406fac7690ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "94d508753efeccb2038baa0d25fb76ed5e53a444515e938f4785a53102254f97"
    sha256 cellar: :any_skip_relocation, ventura:        "929f91494396fef98d36ac237efe6339a991c04c28b966d393b0a52b59f3dba3"
    sha256 cellar: :any_skip_relocation, monterey:       "dce8bcd4761ef8516fba0bcbe7a9f8312f8ef7db8c4f713e2503fa776dc83385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867b6bad2f444d7acbea35af31bff0d7f2b958d5aed2bfcead263d146ece759d"
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
