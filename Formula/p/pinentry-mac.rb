class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  # There is currently no tag available. See
  # https://gpgtools.tenderapp.com/discussions/feedback/18445-new-tag-for-gpgtools-pinentry
  url "https://github.com/GPGTools/pinentry/archive/913d5076f5359d065ff90dee58450d21118e12d0.tar.gz"
  version "1.3.1.1"
  sha256 "d4ea0446183e9b27132a4daf6b70f58e85d3849b5314c994ecee3caa27be1821"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https://github.com/GPGTools/pinentry.git", branch: "master"

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
    # Version 1.3.1.1 returns `1.3.2-unknown`.
    # https://gpgtools.tenderapp.com/discussions/feedback/18445-new-tag-for-gpgtools-pinentry
    assert_match version.major_minor.to_s, shell_output("#{bin}/pinentry-mac --version")
  end
end
