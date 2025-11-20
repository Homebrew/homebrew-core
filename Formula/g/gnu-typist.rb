class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftpmirror.gnu.org/gnu/gtypist/gtypist-2.10.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gtypist/gtypist-2.10.1.tar.xz"
  sha256 "ca618054e91f1ed5ef043fcc43500bbad701c959c31844d4688ff22849ac252d"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f47594d59df3c42dcaeee9f73264471981464416b412786124b0c4a7b3a70df1"
    sha256 arm64_sequoia: "15ba375ec67355fe2043282cd1de4a229fd8d29b4857f73e22b05c8d702fe9e2"
    sha256 arm64_sonoma:  "df74aca9130820bcdbc021116652a23122835e14016003aac9ef0f0d8bdab972"
    sha256 arm64_ventura: "790643311a056fa38bc014e51107bf0984f25d77506f86e60f3843ac8ee5b3cc"
    sha256 sonoma:        "7d10079dae92ce4490e710e6fb6ebe12c6d0703ae8d8a0f31b48c4759a8325d4"
    sha256 ventura:       "7cc31cf6f3f5cd325c69d8b61fe0a75e0f1fd0ab0be47649ca06423a14fed6cf"
    sha256 arm64_linux:   "879de43a7a494a24e1eb6f732b6dadb1a6c9af1de7911b2872a7322503f6e5dd"
    sha256 x86_64_linux:  "15b3985018e2cb520b709f0cf8c0b41307c49caf6756255638a1ddc9f37f3ac6"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/gnu-typist/2.10.patch"
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
