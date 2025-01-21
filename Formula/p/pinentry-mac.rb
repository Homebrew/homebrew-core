class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  revision 1
  head "https://github.com/GPGTools/pinentry.git", branch: "master"

  stable do
    url "https://github.com/GPGTools/pinentry/archive/refs/tags/v1.1.1.1.tar.gz"
    sha256 "1a414f2e172cf8c18a121e60813413f27aedde891c5955151fbf8d50c46a9098"

    # Backport support for newer `libassuan`
    patch do
      url "https://github.com/GPGTools/pinentry/commit/d8ca98aec634256cf4f6801874b6730eda12c5c5.patch?full_index=1"
      sha256 "1490963f2a0ce75879123e56f94064e1b3263ef8aad222c3ca1966807c67ff7e"
    end
    patch do
      url "https://github.com/GPGTools/pinentry/commit/a39ba412ab24721d4edb6476156371f8bf1d3ff9.patch?full_index=1"
      sha256 "277d20f59bd37b3d41e547561b048f6a2af97f96157f1d4adc785bb57f387b5d"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "bc6676111bdf951f0cf02cb73dc697ddb248b202ae355dafd95db76f0d613523"
    sha256 cellar: :any, arm64_sonoma:  "14210a275cd79e331a9f3e743e2b1ab438599aa9606dff0c4f92ea3729ea1bed"
    sha256 cellar: :any, arm64_ventura: "88e9c185744b022538687f5457cf983cd008f3c7e0c88d3de6c88999ab434e4c"
    sha256 cellar: :any, sonoma:        "9d83f7520b7714a41dbba0ca5bb70c04865537a672ab026e91c534b259cd8287"
    sha256 cellar: :any, ventura:       "06b27d956af99787f8f4a4eae11517b9d7ace95d5cebbbbe0db0904660598064"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build # for ibtool
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on :macos

  def install
    system "./autogen.sh"
    system "./configure", "--disable-doc",
                          "--disable-ncurses",
                          "--disable-silent-rules",
                          "--enable-maintainer-mode",
                          *std_configure_args
    system "make"
    prefix.install "macosx/pinentry-mac.app"
    bin.write_exec_script prefix/"pinentry-mac.app/Contents/MacOS/pinentry-mac"
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
