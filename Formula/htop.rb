class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  revision 2

  stable do
    url "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
    sha256 "179be9dccb80cee0c5e1a1f58c8f72ce7b2328ede30fb71dcdf336539be2f487"

    # Running htop can lead to system freezes on macOS 10.13
    # https://github.com/hishamhm/htop/issues/682
    if MacOS.version >= :high_sierra
      patch do
        url "https://github.com/hishamhm/htop/commit/b2771218.patch?full_index=1"
        sha256 "3369f8aed21706d809db062f25fd46bf9c0677712a624697bc5415aa45d5d104"
      end
    end
  end

  bottle do
    sha256 "012058c2b3b3d4061b51ea4782ab4ecbe7063e0256ff4275d5f2f6514617faf4" => :sierra
    sha256 "fbb902d02cb45215128fe96a81132f6eb02afc91de38c8cc21e4ad28171c9119" => :el_capitan
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  option "with-ncurses", "Build using homebrew ncurses (enables mouse scroll)"

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
