class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.7.tar.gz"
  sha256 "b4c9e60344a08d5db37ca7ad00a5b2c76ccb9556354b722d56d55ca7e8b1c707"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87eb60dff0d81ca7f81cf246c2da0be06d6f909e209accf8666247d769a9b219"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51fb51dc19db67ecf6bb7b76454cc83b00171247e9dfc095f46553c6bca8729f"
    sha256 cellar: :any_skip_relocation, monterey:       "bffb52ab8c1c4936c352e9fbb97fc789ddd86546a274f6b35d0f6524315ad007"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d089d60ff92c745931331b2c624178c79bb6640c2022b8dd988ec50ab369e15"
    sha256 cellar: :any_skip_relocation, catalina:       "900864364a7ee537d5f99a765007861b432a435f2613a4c53ae8a570ec12fa7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6ba53a70f69c7db90ab0f69af67ae3abfa95058cdb1ac319b3bfffbdbc6847"
  end

  uses_from_macos "zlib"

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _deflatePending
    # Reported 8 Dec 2016 to madler at alumni.caltech.edu
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "pigz.c", "ZLIB_VERNUM >= 0x1260", "ZLIB_VERNUM >= 0x9999"
    end

    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
