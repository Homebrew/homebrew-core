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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "351867ae899c5212701dff3cbc5aaf3e64ae7f250343de7d10b411365e1ab87e"
    sha256 arm64_sequoia: "10113098841cbf331b3b7ecd70b8fcadc65ee0d863f9fd46671d28325e9e1066"
    sha256 arm64_sonoma:  "7a5ac77635d063e53136ba82f11f793ecabd86340ba3fffbce69463df086c316"
    sha256 arm64_ventura: "e6bb55c082d4b2ceb8328bb4a7723aa3d56168258cad31f0fbc9afad664cb2cb"
    sha256 sonoma:        "13112c4d7607f8ca1f991a1980b1a72636d5359b5a8e6e09826ce5a6167abbff"
    sha256 ventura:       "86720e048ec46eba3a7ede53e34b6b944d802b451758ed5f1cc20a0f87d44f55"
    sha256 arm64_linux:   "ad047d854587f1e4456b6fc7c82afb23dffe5ca589de4affb3fa35da7c594bd6"
    sha256 x86_64_linux:  "b6849416058a2849403173bf34aba0a45d8c27f3a3ff2e43973f0480f6552c00"
  end

  depends_on "ctags" => :build
  depends_on "pkgconf" => :build

  depends_on "libretls"
  uses_from_macos "ncurses"

  def install
    args = %W[
      --disable-silent-rules
      --mandir=#{man}
    ]

    args << "--enable-sandman" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/catgirl 2>&1", 64)
    assert_match "catgirl: host required", output
  end
end
