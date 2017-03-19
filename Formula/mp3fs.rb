class Mp3fs < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v0.91/mp3fs-0.91.tar.gz"
  sha256 "a47b5e351b7660e6f535a3c5b489c5a8191209957f8c0b8d066a5c221e8ecf92"

  depends_on "pkg-config" => :build
  depends_on "lame"
  depends_on "libid3tag"
  depends_on "flac"
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
