class Mp3fs < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v1.1.1/mp3fs-1.1.1.tar.gz"
  sha256 "942b588fb623ea58ce8cac8844e6ff2829ad4bc9b4c163bba58e3fa9ebc15608"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f46f7500a297cee258bca569800abce6538768f2c04510b1218969fcf2fb9649"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libfuse@2"
  depends_on "libid3tag"
  depends_on "libvorbis"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "mp3fs version: #{version}", shell_output("#{bin}/mp3fs -V")
  end
end
