class Mp3fs < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v0.91/mp3fs-0.91.tar.gz"
  sha256 "a47b5e351b7660e6f535a3c5b489c5a8191209957f8c0b8d066a5c221e8ecf92"

  bottle do
    cellar :any
    sha256 "60af0fb41555221a11fcb9cce24afccd6f42e1427f51d9d6d832e713624cc09f" => :mojave
    sha256 "7eec592abb48a4e5acb0b77ba4138b0e2ce8c01817dadf9ace35cdbbcfdd5ea5" => :high_sierra
    sha256 "e711d5da3c4c5f838911938bf5a5e8b754ffacae41c8824caa1ea0576d194718" => :sierra
    sha256 "ac57948842d987524def18895ffe171aaf036e4503315c64eb5152003f67027b" => :el_capitan
    sha256 "a1f89f74c8de87c9559fe1dc2f26ec0af5ee5d9d60d1f8962f6eaa1af243f25b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libid3tag"
  depends_on :osxfuse

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /mp3fs version: #{Regexp.escape(version)}/,
                 shell_output("#{bin}/mp3fs -V")
  end
end
