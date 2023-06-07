class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.34.tar.xz"
  sha256 "691e3f3654bc10d022bb0310234d0bc2d8c075a698f09924d9ebed8f506fda20"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/mpc/0/"
    regex(/href=.*?mpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5d5d6c6a78d3afb42b97965b9d5b2ad6e6e6e176ae11e10d81a17814971f8400"
    sha256 cellar: :any, arm64_monterey: "ab7dca71a458e5df0f35443eb3bcee79318dc8e81d1e6994b3c0fec457c516bd"
    sha256 cellar: :any, arm64_big_sur:  "18b5ad4dc2effa515f23fca972e6793caa382398122538054992b5d2fd8e7855"
    sha256 cellar: :any, ventura:        "3a84f54a0d401bcc5a3c67aba6dd32feef7e5248a74a441f02d1611601fd0ed0"
    sha256 cellar: :any, monterey:       "37c0df291c472821d14b459e08d3e9a65971f049869b9f7dc9a14b5c436005de"
    sha256 cellar: :any, big_sur:        "040a5ce6e08581306ab2aa274e79860390ccb3f0099b7bc8fe132f9a24ba5956"
    sha256 cellar: :any, catalina:       "1bcbaf7a78216c6ff9482c1b7d7e5df30ebf5c1137e8b35c22996c1e2dc0dbf3"
    sha256               x86_64_linux:   "518acb382cf9a16a5fad35023892db930b732d9329a6ffe3e0751c7b7bcb6e3c"
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
