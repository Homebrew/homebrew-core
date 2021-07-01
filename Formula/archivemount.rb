class Archivemount < Formula
  desc "File system for accessing archives using libarchive"
  homepage "https://www.cybernoia.de/software/archivemount.html"
  url "https://www.cybernoia.de/software/archivemount/archivemount-0.9.1.tar.gz"
  sha256 "c529b981cacb19541b48ddafdafb2ede47a40fcaf16c677c1e2cd198b159c5b3"

  bottle do
    sha256 cellar: :any, catalina:    "68c3994948be590e8ee5e9a9de00182162135a76b0a5dd780c7d8b067a480062"
    sha256 cellar: :any, mojave:      "439cdd8d7c962cf9a5144e20206ddaeaabc15c1752c58acd059e31976e254f6a"
    sha256 cellar: :any, high_sierra: "428113b60673b6bb8be9467587f1d82bf4c9447c7f0bbdea47749bed3ec86798"
  end

  depends_on "pkg-config" => :build
  depends_on "libarchive"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV.append_to_cflags "-I/usr/local/include/osxfuse"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system bin/"archivemount", "--version"
  end
end
