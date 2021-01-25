class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  url "https://github.com/GPGTools/pinentry/archive/v1.1.0.3.tar.gz"
  sha256 "1ac83f1688d02518da5ddce1ceaa7e40893080a8d2f015b759dfaddf1b14545c"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https://github.com/GPGTools/pinentry.git", branch: "dev"

  bottle do
    cellar :any
    sha256 "bf4fab5722e014d64397d0cc9078a95779f7b2553f858af4444ca913c3ce979f" => :big_sur
    sha256 "b33a7f22470f2fc0f81fa45259c0d338196d0a2c1a4dff3ee7e38cc002c16744" => :arm64_big_sur
    sha256 "149e9ddc31176346b936fbec386c49d3fb322132d65d415854033203ba1db467" => :catalina
    sha256 "90c757fe0590e14c8e2d13a6e11629eb1f6893696b720b849a19db09b3c932dd" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build
  depends_on "gettext"
  depends_on "libassuan"

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
