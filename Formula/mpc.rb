class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.31.tar.xz"
  sha256 "62373e83a8a165b2ed43967975efecd3feee530f4557d6b861dd08aa89d52b2d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4453dae7764d8c2f94fe581f1f35646e159c6483c2db7b0aa79b862ca6c8d627" => :catalina
    sha256 "d7f43be3ae391ec5987cc2b49653b202dfa1798481b32209109b340adf309b29" => :mojave
    sha256 "cf0a89f4b0e4d419cae88a989daa3ff015cf11d82904817c6fe1a3c08ca287db" => :high_sierra
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
