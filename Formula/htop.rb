class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"

  stable do
    url "https://hisham.hm/htop/releases/2.1.0/htop-2.1.0.tar.gz"
    sha256 "3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748"

    # Remove for > 2.1.0
    # Upstream commit from 25 Mar 2018 "Keep scanning threads for versions
    # before High Sierra 13.0.0 and after 13.3.0."
    patch do
      url "https://github.com/hishamhm/htop/commit/52e2884f.patch?full_index=1"
      sha256 "5daeb1a532cf8e4524a4f3093792a687d77b50c3f78c713b410ebb2bc9ae79b2"
    end
  end

  bottle do
    sha256 "4e65d1d92ef616935ee5b6e498e05ad92e733ced3a41a408c2b30ce7a6b5a1ed" => :high_sierra
    sha256 "4e9fe44dc41ca415f3465b8445d06df7ed319ca50522758dc44298daff9d9de5" => :sierra
    sha256 "adf2b63b4fa6d96efc9cfb7c5726d14f5b70a6f38c8e7cea38e0befd26c6ca7f" => :el_capitan
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

  depends_on "pkg-config" => :build
  depends_on "ncurses" => :optional

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    htop requires root privileges to correctly display all running processes,
    so you will need to run `sudo htop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output("#{bin}/htop", "q", 0)
  end
end
