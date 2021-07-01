class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.3/avfs-1.1.3.tar.bz2"
  sha256 "4f4ec1e8c0d5da94949e3dab7500ee29fa3e0dda723daf8e7d60e5f3ce4450df"

  bottle do
    sha256 catalina:    "6f496a30b6bd1c8eba1005e4bc0da26b53353effab3f447cf8d43a669ad7a6b5"
    sha256 mojave:      "1e75ce4753a0d9a9af12e4a718537a9e2398fd535413b72505dd126a33610fe6"
    sha256 high_sierra: "690fbe0161f0c5ce4ec737e67624b54bfcd7825efa8b554e1773691365dcd6ed"
  end

  depends_on "pkg-config" => :build
  depends_on macos: :sierra # needs clock_gettime
  depends_on "openssl@1.1"
  depends_on "xz"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
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
    system bin/"avfsd", "--version"
  end
end
