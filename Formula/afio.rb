class Afio < Formula
  desc "Creates cpio-format archives"
  homepage "http://members.chello.nl/~k.holtman/afio.html"
  url "http://members.chello.nl/~k.holtman/afio-2.5.1.tgz"
  sha256 "363457a5d6ee422d9b704ef56d26369ca5ee671d7209cfe799cab6e30bf2b99a"
  head "https://github.com/kholtman/afio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "365c570b59790368b8ef4f47b375ad8bc64b4017f89ecfb6facca16d8a8ea672" => :mojave
    sha256 "ae3eea7cafc324521405f6ebfe697e04f109dd48b66e60054238ffba470e867b" => :high_sierra
    sha256 "5863378152ea720ffb5614cceb27eabcd98a2e2734810830f7908af3262ee303" => :sierra
    sha256 "4bbebea8c0ea4bc79d0614dcf04a12aa44282198a0af4d9fee40fa0b70abb745" => :el_capitan
    sha256 "c729e81f3952e8475ec4fe1ed4dc5a870e550af781b877a610a09686e9fe8a71" => :mavericks
    sha256 "74a74e153dda86a7d08ab9cf293c1ac8796f64d1f94f0f31590ee96de88b2c3d" => :mountain_lion
    sha256 "7ff316d9e43e5a55b95d381f13f0429a87ff36d39425fb62ec2af2cb00fc22af" => :lion
  end

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "afio"
    man1.install "afio.1"

    prefix.install "ANNOUNCE-2.5.1" => "ANNOUNCE"
    prefix.install %w[INSTALLATION SCRIPTS]
    share.install Dir["script*"]
  end

  test do
    path = testpath/"test"
    path.write "homebrew"
    pipe_output("#{bin}/afio -o archive", "test\n")

    system "#{bin}/afio", "-r", "archive"
    path.unlink

    system "#{bin}/afio", "-t", "archive"
    system "#{bin}/afio", "-i", "archive"
    assert_equal "homebrew", path.read.chomp
  end
end
