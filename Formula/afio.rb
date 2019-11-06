class Afio < Formula
  desc "Creates cpio-format archives"
  homepage "https://github.com/kholtman/afio"
  url "https://github.com/kholtman/afio/archive/v2.5.2.tar.gz"
  sha256 "c64ca14109df547e25702c9f3a9ca877881cd4bf38dcbe90fbd09c8d294f42b9"
  head "https://github.com/kholtman/afio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0f6de009260949cb2199851b08f77fb82b99b92cd1c9e680cd557ed2515b42f" => :mojave
    sha256 "38f4da84d7056b33a6b7685f5206c32691ea673824faf3a971045feee8f52d93" => :high_sierra
    sha256 "e235a62bd03e7c65ebd55b6e47d668d50bf7681d8be9a4022263a835333a6047" => :sierra
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
