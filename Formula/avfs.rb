class Avfs < Formula
  desc "Virtual file system that facilitates looking inside archives"
  homepage "https://avf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/avf/avfs/1.1.4/avfs-1.1.4.tar.bz2"
  sha256 "3a7981af8557f864ae10d4b204c29969588fdb526e117456e8efd54bf8faa12b"

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
    depends_on "libfuse@2"
  end

  def install
    args = %W[
      --disable-silent-rules
      --enable-fuse
      --enable-library
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *std_configure_args, *args
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
