class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://hisham.hm/htop/"
  url "https://hisham.hm/htop/releases/2.2.0/htop-2.2.0.tar.gz"
  sha256 "d9d6826f10ce3887950d709b53ee1d8c1849a70fa38e91d5896ad8cbc6ba3c57"

  bottle do
    rebuild 1
    sha256 "668d7b889f1f15adf76efad7324688dc63f0529862cde70b11597cebbaeb4406" => :mojave
    sha256 "07cd259ed88e88ad7d1acbc92916dd3c6a069fdbbd65953de7838fd0d9ba0183" => :high_sierra
    sha256 "2e8c58bd5c46192178af2c31e8c7f97118ef09d301b2d3c402e08562d6927844" => :sierra
  end

  head do
    url "https://github.com/hishamhm/htop.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

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
