class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.33.tar.xz"
  sha256 "4f40ccbe18f5095437283cfc525a97815e983cbfd3a29e48ff610fa4f1bf1296"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/mpc/0/"
    regex(/href=.*?mpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c86764449bddde59112a1627ff4c6676100afc87a2d39346c2f4a13677bc5bfb"
    sha256 cellar: :any, arm64_big_sur:  "8062f7af33fe3603b4c625509f4c80570d790b15922287025ef7333748dae279"
    sha256 cellar: :any, monterey:       "f00ccbb53d1ed598c3de7b2723355debfd5d9bc29e105469150a7ec7f7a3ccfc"
    sha256 cellar: :any, big_sur:        "cc01508026db65016ee6e2ec1f6663921a5c5ace5c76ea51ffbd1b0b7ade5e63"
    sha256 cellar: :any, catalina:       "341a4c3cef23004a47f37fa299047e63baedceb07405813d6fc112c9ad7d4ff2"
    sha256 cellar: :any, mojave:         "29742180fafe0fffeba3fc09c3d355395084ef3d063004347a96bc37c72682db"
    sha256 cellar: :any, high_sierra:    "84bd2c475a7880bf1f36c560a5696c12c27ff6cdb5cd907082d14ffd094b1081"
    sha256               x86_64_linux:   "e19c9867bd2852976181a0552b82e1206a9c046f7ce606448ee9289220c39764"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "meson", *std_meson_args, ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"

    bash_completion.install "contrib/mpc-completion.bash" => "mpc"
    rm share/"doc/mpc/contrib/mpc-completion.bash"
  end

  test do
    assert_match "query", shell_output("#{bin}/mpc list 2>&1", 1)
    assert_match "-F _mpc", shell_output("bash -c 'source #{bash_completion}/mpc && complete -p mpc'")
  end
end
