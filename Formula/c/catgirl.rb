class Catgirl < Formula
  desc "Terminal IRC client"
  homepage "https://git.causal.agency/catgirl/about/"
  url "https://git.causal.agency/catgirl/snapshot/catgirl-2.2a.tar.gz"
  sha256 "c6d760aaee134e052586def7a9103543f7281fde6531fbcb41086470794297c2"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://git.causal.agency/catgirl"
    regex(/href=.*?catgirl[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  depends_on "ctags" => :build
  depends_on "pkgconf" => :build

  depends_on "libretls"
  uses_from_macos "ncurses"

  def install
    args = %W[
      --mandir=#{man}
    ]

    args << "--enable-sandman" if OS.mac?

    system "./configure", "--disable-silent-rules", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output(bin/"catgirl 2>&1", 64)
    assert_match "catgirl: host required", output
  end
end
