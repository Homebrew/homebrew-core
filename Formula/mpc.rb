class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.33.tar.xz"
  sha256 "4f40ccbe18f5095437283cfc525a97815e983cbfd3a29e48ff610fa4f1bf1296"

  bottle do
    cellar :any
    sha256 "341a4c3cef23004a47f37fa299047e63baedceb07405813d6fc112c9ad7d4ff2" => :catalina
    sha256 "29742180fafe0fffeba3fc09c3d355395084ef3d063004347a96bc37c72682db" => :mojave
    sha256 "84bd2c475a7880bf1f36c560a5696c12c27ff6cdb5cd907082d14ffd094b1081" => :high_sierra
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
    assert_match "-F _mpc", shell_output("source #{bash_completion}/mpc && complete -p mpc")
  end
end
