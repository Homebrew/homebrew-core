class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.7.24.tar.gz"
  sha256 "3bf43c5809c8d50066eaeaea5a115f6503c57a38c151975b710aa2bee857b65e"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c286f0f0525b1399b9b4b715135a2120c23a297db1b4476431673385e6e4fa5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e57b34637969d1125b7999ebef0f5cdd105e0898deae72a59deffb696953e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bc92daab79045bf093e9c9f472a2ff85c3b591fcdb31d62b8c6cf17d4b42b06"
    sha256 cellar: :any_skip_relocation, ventura:        "0468258418ba5bfcfac151ae9d150928d4fb38727d47d5352b553f355cd8e16d"
    sha256 cellar: :any_skip_relocation, monterey:       "465850891540f18c3342cf189700784327967cff0bafa08fdb52e51778be59ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7e1729eb6fb3efab1eac38398399f894db800ae97a2dc3783314205aa4f5431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33dac363479b61cdf849f70f2885ca5e6448c69d9c46cc31e1f9ca216c38a4e"
  end

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
