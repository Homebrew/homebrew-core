class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.3.tar.gz"
  sha256 "37f4bc0177534782609ec3a67ec413548d3f2cabff7c4c0bc8a92a36e49c6877"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7910094fb9d9c7653c03df03d4b46a13266d685cdf41e1ffc765aaa40c6bd3d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a79fbaaa5a4d95b1d7a1075ce197aaf6430575a3ad897073fae481c45b3092e"
    sha256 cellar: :any_skip_relocation, catalina:      "9029316df99f2db7c5771c7d186d6e749cca6189f0810b816048c771ddd47cc6"
    sha256 cellar: :any_skip_relocation, mojave:        "dcf61ed173b28d67502357a7a4eb6bc3ac3c656df59556099591906bcb3a3e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d63c078238d5709cfec35acb98d61cba8fc31ed4f1d890bdd6eb512f160b02"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
