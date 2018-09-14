class Libfishsound < Formula
  desc "Decode and encode audio data using the Xiph.org codecs"
  homepage "https://xiph.org/fishsound/"
  url "https://downloads.xiph.org/releases/libfishsound/libfishsound-1.0.0.tar.gz"
  sha256 "2e0b57ce2fecc9375eef72938ed08ac8c8f6c5238e1cae24458f0b0e8dade7c7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f232242d49e8c2ae954e282e879e4a4a86b80d3e46364d74247af92efd613d96" => :mojave
    sha256 "726c79b6e3ce5d71e9cf1d6b556a6daed33b5e8bd7269e2219b1474549dac17d" => :high_sierra
    sha256 "50187bc6adea9322f20e1706d66859c941d6d2e8d1d8bfab091f088b20061760" => :sierra
    sha256 "9cf94c3c6963895940e8720aef21c29b001257c918fce6b65685c33f8430f0e4" => :el_capitan
    sha256 "4fcfc4270d73ac2b0e8d8a4d1fe6b94a1093502b802ed327febb5286ad5140b9" => :yosemite
    sha256 "b8c54b7d3b2bc5e433b20f89f67c6cb3d03b18e0881126a526ae1ff028d8c220" => :mavericks
    sha256 "f839c0de6981edbc6a522fe300693746d2e2744fa430a8dd4cf1c09f0e4268b5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
