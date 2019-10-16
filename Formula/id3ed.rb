class Id3ed < Formula
  desc "ID3 tag editor for MP3 files"
  homepage "http://code.fluffytapeworm.com/projects/id3ed"
  url "http://code.fluffytapeworm.com/projects/id3ed/id3ed-1.10.4.tar.gz"
  sha256 "56f26dfde7b6357c5ad22644c2a379f25fce82a200264b5d4ce62f2468d8431b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9520d236327bce01cc292421934e19476163d8d72b4848740d3067cbc71b2572" => :catalina
    sha256 "2079b26fd26395f4eb016c61afafa007045d7b87b5030b05650705959c3bd87a" => :mojave
    sha256 "c31762b13640d1e9713ea26df41d5e9cb675a8d3565cd84b70efc526663ddfb8" => :high_sierra
    sha256 "e930552e37599e7926efebaf0d893f888576a26bddef6a91e356cf1b5de15b9e" => :sierra
    sha256 "6448c8e19c8e0874ed5141193c7db06c443ac6c33ab2f6bbe8811098b063c0d1" => :el_capitan
    sha256 "8ca64da5c8c0cbbc7ec64af436fcf3a7ae457c8d8a8073887fc63ec4e89c98b9" => :yosemite
    sha256 "8dd4a14922e94245dd016a266aa23c7bcebb18a56e574c8179df83c2d68ff23c" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--bindir=#{bin}/",
                          "--mandir=#{man1}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/id3ed", "-r", "-q", test_fixtures("test.mp3")
  end
end
