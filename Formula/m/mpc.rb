class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.35.tar.xz"
  sha256 "382959c3bfa2765b5346232438650491b822a16607ff5699178aa1386e3878d4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/mpc/0/"
    regex(/href=.*?mpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a325c2d6c27f05beb9fda4c43029512fe2c8542793a3773cf27ac4684f794904"
    sha256 cellar: :any,                 arm64_sequoia:  "db50052b3d26b915d7dc62a48b0a321a8c7508e1432db97da28d784011b267bd"
    sha256 cellar: :any,                 arm64_sonoma:   "f1e59f68f047fc8dd086e5e794345af28749a3d2b83e5d922c1245a6f32a1c36"
    sha256 cellar: :any,                 arm64_ventura:  "331071de8326f5a6fa77df9ccd4c0631935df430e87842561f2879c7c313c06d"
    sha256 cellar: :any,                 arm64_monterey: "cf09306f0bc1483fc89e9eaadf2804a451c679d1d2c5df6c22093de692edf3db"
    sha256 cellar: :any,                 sonoma:         "1dd3c6edc2ac8b09944f66a93a0cd3bad09afda8c0ae03cd6880a4aa62996789"
    sha256 cellar: :any,                 ventura:        "ff84bbc1db8188aa75c9af29d4c0fb3c46f501c806db958493d84bcf2ee6a9d3"
    sha256 cellar: :any,                 monterey:       "d3ca1dc058c82ba52016809f097666105535f5346a91b0c3b1092300e6831214"
    sha256                               arm64_linux:    "0acf954601f5908c4fb4f2488b46f84abbed2759b8189eb237823a80c79adcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9195f0deda2f2ec4a6a9863275299136388eccfab23b6d46d682eca7e773591"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libmpdclient"

  def install
    system "meson", "setup", "_build", *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"

    bash_completion.install "contrib/mpc-completion.bash" => "mpc"
    rm share/"doc/mpc/contrib/mpc-completion.bash"
  end

  test do
    assert_match "query", shell_output("#{bin}/mpc list 2>&1", 1)
    assert_match "-F _mpc", shell_output("bash -c 'source #{bash_completion}/mpc && complete -p mpc'")
  end
end
