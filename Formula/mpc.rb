class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.28.tar.gz"
  sha256 "53385c2d9af0a0025943045b46cb2079b300c1224d615ac98f7ff140e968600d"

  bottle do
    cellar :any
    sha256 "26f8fd128483fa5ce7b3543f4152c1f1ee49ea6e2ec8f5e59874991d84627e96" => :sierra
    sha256 "40b5cd34fd7b212a4d83476f0511bdd50bdc7533450665fc1ca5f0f008d510b7" => :el_capitan
    sha256 "b521e1e20acbe6b1cfb0bc52cd810e8fc8c5b8ae69441964122606c81bfc0dea" => :yosemite
    sha256 "8e96cbd74506a8d2b86e3fab070bdb36a30fe2fba987d928053d160e5b036f6f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end
