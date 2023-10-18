class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.3/mighttpd2-4.0.3.tar.gz"
  sha256 "1a43390e921ab1b1b473d5bf65b2dcf27d0a8466e3243c2dab5d0c3de32bf9e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c35095899e88d3420c7e22f6e930eec3cec9997565227b92b19cdccc83c43287"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14ce8d8f29c64398617a7c0559f9a6e6918d462257656f4b5fe4eb2ac796dce7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f18f2da847b14b72375b9ab0a95af7baf2b839d382f37f07a1543721710a1d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fbe2af8cad585cf43584f39078f5b5ba00cddea477ee35813cda64961cac1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "584c975be5d7089cd2e41ce5d270bd09315df1e3b2f12db19ebf9a8cade71c71"
    sha256 cellar: :any_skip_relocation, ventura:        "9274fce540911647838ea0f26304a60f4e3dcf82480e9f06bb24c74e92399888"
    sha256 cellar: :any_skip_relocation, monterey:       "fce6e11a2aa622fb038e83c5334257cad896246cde293b8ea4fcf10c8e6a8f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b833ec3f97ecc2c53f343df423521606ffbe44a813e891e0b94e1c4fca6179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8d692ca461d3f352302f9dfecebc2bac125dd7296db177c53f4bee5e92f895"
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
