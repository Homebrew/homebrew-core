class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://julius.osdn.jp"
  url "https://github.com/julius-speech/julius/archive/v4.4.2.1.tar.gz"
  sha256 "784730d63bcd9e9e2ee814ba8f79eef2679ec096300e96400e91f6778757567f"

  bottle do
    cellar :any
    sha256 "1951aa8bcb7dd03c77dee80c0bcc402c72147e9ebb9442701fdf1b51594036ad" => :sierra
    sha256 "c11e98646dcdc34f2da621298cbef01429d91c81f8f44068518c0599ee4ff144" => :el_capitan
    sha256 "42b7494d1a3f3d74cef3363a329c93df0cfb5903399193892c5834a7d482c394" => :yosemite
    sha256 "e4cdb2839882a69a95e9136e232e616e8e4ee20766dbb7ed480cde333ba50527" => :mavericks
    sha256 "14c430143ee00b9981e39e91450be1c2442636b4f37d9c51e432d3377f747449" => :mountain_lion
  end

  depends_on "libsndfile"

  # Upstream PR from 9 Sep 2017 "ensure pkgconfig directory exists during
  # installation"
  patch do
    url "https://github.com/julius-speech/julius/pull/73.patch?full_index=1"
    sha256 "b1d2d233a7f04f0b8f1123e1de731afd618b996d1f458ea8f53b01c547864831"
  end

  def install
    # Upstream issue "4.4.2.1 parallelized build fails"
    # Reported 10 Sep 2017 https://github.com/julius-speech/julius/issues/74
    ENV.deparallelize

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius --help", 1)
  end
end
