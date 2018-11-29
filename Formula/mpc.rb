class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.31.tar.xz"
  sha256 "62373e83a8a165b2ed43967975efecd3feee530f4557d6b861dd08aa89d52b2d"

  bottle do
    sha256 "a0978aee21d1d4326cac85904ad4dc381ffd0fae96c66b98912ecd5260b548a4" => :mojave
    sha256 "70bf0925e52814689cc58579288dafbefcd512caf3e4bcaa48f78d6c84fd7f36" => :high_sierra
    sha256 "34dc577f9ac9551204d7c36448468da5a69c152b2de21622fc5e649c051a98de" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
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
