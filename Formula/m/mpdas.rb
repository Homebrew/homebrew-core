class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.5.tar.gz"
  sha256 "c9103d7b897e76cd11a669e1c062d74cb73574efc7ba87de3b04304464e8a9ca"
  license "BSD-3-Clause"
  head "https://github.com/hrkfdn/mpdas.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?mpdas[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "a33d1f587e538bbc81db4d3bf60dc7c37c82ee462400c6051785e4338f1c46e1"
    sha256 arm64_monterey: "89b5e45abcb88c8df236dea703162ed9d7f372c0872c3af23630c56e18e31c8e"
    sha256 arm64_big_sur:  "a7fd32d05844b78fb8eede1ff4a1285e531250919e296166f0eb74d6a9f0cd39"
    sha256 ventura:        "559fcd0228ecbdcca8fd8147e611c05d6e71e071823090e669da2985140bbf5b"
    sha256 monterey:       "25dd98ffb770fa018112f3014ae2574ab346b2d54d542b4feab516f264f30ced"
    sha256 big_sur:        "1f41b8a297270de980e814104f1a74d9437777caa9443686fb251cac6625494b"
    sha256 catalina:       "ae3eaddea864370fbcb2ad3f815165ba4f79f57470cbf0b3d81c781f0aaccc37"
    sha256 mojave:         "4b6a70ab4c6599598c88dc0da91b3646a5d36bc7db9c174ed1cad387861f4370"
    sha256 x86_64_linux:   "863be659b7b2e9ee5e61c73d284d0a753430f438fbf1225efcee4120850883d2"
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man1}", "CONFIG=#{etc}", "install"
    etc.install "mpdasrc.example"
  end

  service do
    run opt_bin/"mpdas"
    keep_alive true
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"mpdas", "-v"
  end
end
