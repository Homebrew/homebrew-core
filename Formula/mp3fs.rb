class Mp3fs < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v1.0/mp3fs-1.0.tar.gz"
  sha256 "cbb52062d712e8dfd3491d0b105e2e05715d493a0fd14b53a23919694a348069"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "26d991c2fb34055035c01d12033f28b5a694954ad9b3f650658dfa1ebc9994ea" => :catalina
    sha256 "a9f6095147b767a892891bdc0a44b61eef40880e38bc50e54c0a30d96de89985" => :mojave
    sha256 "b3b2e431e9a782dbde9d758505c372a0d6ed60eff44ebc21c9b979c01b0df189" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libid3tag"
  depends_on "libvorbis"

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /mp3fs version: #{Regexp.escape(version)}/,
                 shell_output("#{bin}/mp3fs -V")
  end
end
