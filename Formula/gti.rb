class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.7.0.tar.gz"
  sha256 "cea8baf25ac5e6272f9031bd5e36a17a4b55038830b108f4f24e7f55690198f7"
  head "https://github.com/rwos/gti.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f087f6d12603c40322d99c2219d4ff1fa365e2465ff4acfcd76359d5f7172472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab217e77e6cc4491d0b2e16390ac55d5c6e32d2f1ceced56ff7848a8bdd2453"
    sha256 cellar: :any_skip_relocation, monterey:       "5c0d6258e9340d4734467da6f79945dacae879bae9a5c2ef662f5c2d9cc96974"
    sha256 cellar: :any_skip_relocation, big_sur:        "2466fec7628acfe3d24bb93cd31313d353a808f373e3c666b7b9c52326f45a0d"
    sha256 cellar: :any_skip_relocation, catalina:       "dc2f7bf9b442294a044b782321689783cd3fd93a465a9604db606b2b420e4443"
    sha256 cellar: :any_skip_relocation, mojave:         "2e1f996a67020a9bd842b41d0ac7d6e5ef0791fbc7fd57ffe3e9b7aacc1ee6de"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9d46e56c0f79ba9d81e40bc1edc7b4ff1a9c9eeb4dbcb087827dec5b84c4f82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46900190c8fab2b76aab2362ba57282ff55c659e45af45349a2ed5ea762448bc"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
