class Mighttpd2 < Formula
  desc "HTTP server"
  homepage "https://kazu-yamamoto.github.io/mighttpd2/"
  url "https://hackage.haskell.org/package/mighttpd2-4.0.7/mighttpd2-4.0.7.tar.gz"
  sha256 "28bb7c1309d71a276eab7b7ad0f78c00c5e7119a656ede408619cf676e749225"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "55f9e72b534493ca05a670a39548097f87d215f5cecdd989deab5ac2d1ad3392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ce8b2007ade99047af65d374ba0b01bea3f382006db449857be9f196cf3df20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be986030a6d0bf9e7bcfc5218f57d350f30fdaff17b905ef45ed4d6623e44f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b3fc20fd35255a3b98d9d4150ceb05a532944e24168f07c82341f66c7775d85"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc899dbd255789fc44e49d0a94b804c3773302f2c1a7de1d7da0d18fdce511ff"
    sha256 cellar: :any_skip_relocation, ventura:        "800fca27c5bc71d56aba593940f36087b4fda948301ede2dd2a8f159e1796578"
    sha256 cellar: :any_skip_relocation, monterey:       "4dfa736657e5b293cf440d42ad467d8fdbf34fb67c69dbe1272a814a88932684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2edf3a1ccc28fac58f9a784c43d0f6de37e8d8c57ed2059c4d8a5f408d701361"
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
