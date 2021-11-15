class Id3ed < Formula
  desc "ID3 tag editor for MP3 files"
  homepage "http://code.fluffytapeworm.com/projects/id3ed"
  url "http://code.fluffytapeworm.com/projects/id3ed/id3ed-1.10.4.tar.gz"
  sha256 "56f26dfde7b6357c5ad22644c2a379f25fce82a200264b5d4ce62f2468d8431b"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?id3ed[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec8b1d5f390522de640fa294bf2d3c45b2f8aba7ed9711cb7698ed0ce998e935"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0adb83739ee928667c488d4213369f5854900380f159219d0f04dc929ff731cc"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e6c6805d84b99c9302f9656e19c6430489d6518ff154f6983e2319e5d24c8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a560e42fb11482b14d22079ffa0ffb2dd2307f5e740b22acd2636b4fa6e4a307"
    sha256 cellar: :any_skip_relocation, catalina:       "9520d236327bce01cc292421934e19476163d8d72b4848740d3067cbc71b2572"
    sha256 cellar: :any_skip_relocation, mojave:         "2079b26fd26395f4eb016c61afafa007045d7b87b5030b05650705959c3bd87a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c31762b13640d1e9713ea26df41d5e9cb675a8d3565cd84b70efc526663ddfb8"
    sha256 cellar: :any_skip_relocation, sierra:         "e930552e37599e7926efebaf0d893f888576a26bddef6a91e356cf1b5de15b9e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6448c8e19c8e0874ed5141193c7db06c443ac6c33ab2f6bbe8811098b063c0d1"
    sha256 cellar: :any_skip_relocation, yosemite:       "8ca64da5c8c0cbbc7ec64af436fcf3a7ae457c8d8a8073887fc63ec4e89c98b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0955550881e7f35fdf76fe198de7f2c1908d749978587c55cc9b5574ddafb2fd"
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
