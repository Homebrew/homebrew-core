class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.1.0/htop-2.1.0.tar.gz"
  sha256 "3260be990d26e25b6b49fc9d96dbc935ad46e61083c0b7f6df413e513bf80748"
  revision 1

  bottle do
    sha256 "86490c7b199936fb39bc6b2840f70abd3083aaa2c8f6a182629058ebefed0a6d" => :high_sierra
    sha256 "193cc35f5df3f87bb1c6b10cc2bf00524247437c86b2b000574668d8010d6ee8" => :sierra
    sha256 "4bf2bb5813f8544f7c249bd72ce3818cc2df6487ba421aa09951c20761ca9ddd" => :el_capitan
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
