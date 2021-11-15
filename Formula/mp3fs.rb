class Mp3fs < Formula
  desc "Read-only FUSE file system: transcodes audio formats to MP3"
  homepage "https://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v1.1.1/mp3fs-1.1.1.tar.gz"
  sha256 "942b588fb623ea58ce8cac8844e6ff2829ad4bc9b4c163bba58e3fa9ebc15608"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6d1586bc27d210c2ee54b09a26b369c48fb932e8aae2be48dc03f577e1299854"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "lame"
  depends_on "libid3tag"
  depends_on "libvorbis"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./configure", *std_configure_args
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
    assert_match "mp3fs version: #{version}", shell_output("#{bin}/mp3fs -V")
  end
end
