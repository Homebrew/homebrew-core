class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.30.tar.xz"
  sha256 "65fc5b0a8430efe9acbe6e261127960682764b20ab994676371bdc797d867fce"

  bottle do
    rebuild 1
    sha256 "f8aacc306782434f8f8a681701a1180cec977c687f599f9c575ec2bd5b68c581" => :mojave
    sha256 "59b14683a0acd8f11bb1e7b56e9f5e5c604b055a111c0f8e6ad48089248ef6f2" => :high_sierra
    sha256 "e606214d00ed9c69c1877efa543d8e5120fef6f1df238de48776aacb59af00de" => :sierra
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
