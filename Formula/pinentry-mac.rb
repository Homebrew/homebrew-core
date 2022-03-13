class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  url "https://github.com/GPGTools/pinentry/archive/v1.1.1.1.tar.gz"
  sha256 "1a414f2e172cf8c18a121e60813413f27aedde891c5955151fbf8d50c46a9098"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https://github.com/GPGTools/pinentry.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "7ebbe0d43dcdf88c28e7df80ddb21ca669968107beaf7dd224efc461cc25474b"
    sha256 cellar: :any, arm64_big_sur:  "64958e3763e548e154a485382fdab8525e7df237c9198ce5b60e4966ba91fc41"
    sha256 cellar: :any, monterey:       "3951ca662de62018c9a82921a29f9a06989f0efe25f68c84107c12f3a485be88"
    sha256 cellar: :any, big_sur:        "44b9e026ae382505ac98e01aca3d97727deff1dc57e7a15e6aae08371142439c"
    sha256 cellar: :any, catalina:       "2957715c9a914da6774f4f28523962aa512eb89858aae57a35bc299d2458932c"
    sha256 cellar: :any, mojave:         "e7a94a9c022f0996b24ff4da4b9e5cee34cf681a8571320b0f49e129d6fde8e0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build
  depends_on "gettext"
  depends_on "libassuan"
  depends_on :macos

  def install
    system "autoreconf", "-fiv"
    system "autoconf"
    system "./configure", "--disable-ncurses", "--enable-maintainer-mode"
    system "make"
    prefix.install "macosx/pinentry-mac.app"
    bin.write_exec_script "#{prefix}/pinentry-mac.app/Contents/MacOS/pinentry-mac"
  end

  def caveats
    <<~EOS
      You can now set this as your pinentry program like

      ~/.gnupg/gpg-agent.conf
          pinentry-program #{HOMEBREW_PREFIX}/bin/pinentry-mac
    EOS
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/pinentry-mac --version")
  end
end
