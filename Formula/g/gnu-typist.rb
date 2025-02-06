class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.10.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.10.1.tar.xz"
  sha256 "6b734c307e6d0a69af1d3b1ca3c97282ddbce7359b6b816f0f120460c6795ffb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "244d2aeb4b8d7c3f510812a347ea94d6bfdcc83c26ac5bbe4257306ad002d33b"
    sha256 arm64_sonoma:  "cbf0d47fb143b0f938e989c9067053b207433a71e93a2faa48088b38c52c66d2"
    sha256 arm64_ventura: "f58083be0b713eeefb687b211e5504e1afa45f309279535807324aa6d09a71a2"
    sha256 sonoma:        "52a5ba01a1811bd23dfae3300f545e480ec1a22e19aebebc5c09f7deade9b81f"
    sha256 ventura:       "ea26b88799d31db4328f08e9fe8b630c9b649d48de36aa68e551a8afc0300939"
    sha256 x86_64_linux:  "47df2b292debdcf816185d968d4ec8ef2affea9a3554c9098d883a0b8e0bfe24"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5593da4ce6302d9ccaef9fde52bf60a6d4a669b/gnu-typist/2.10.patch"
    sha256 "26e0576906f42b76db8f7592f1b49fabd268b2af49c212a48a4aeb2be41551b3"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end
