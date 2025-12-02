class PinentryMac < Formula
  desc "Pinentry for GPG on Mac"
  homepage "https://github.com/GPGTools/pinentry"
  url "https://github.com/GPGTools/pinentry/archive/refs/tags/v1.3.1.1.tar.gz"
  sha256 "ba929dd1c57b102fbfca12bc2d784be441498e7c82ee97a1231cbe03dcda7ae9"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]
  head "https://github.com/GPGTools/pinentry.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "784844f7e5ccb8be3b5eeb567318c8948f492c57e70289189a296dcdaa31cb7d"
    sha256 cellar: :any, arm64_sequoia: "f0cacdc9497edf7391983fe84573ddfd826d0315680847a3f78ec020b6d145e5"
    sha256 cellar: :any, arm64_sonoma:  "6c879dba2621079072e566b95c00f96e7731a164dc6206054933058375df7014"
    sha256 cellar: :any, arm64_ventura: "9fd717f5a5b6223bd307503d72290ba678b8f0af9d185e952741bd6f73dab482"
    sha256 cellar: :any, sonoma:        "bac8b8241d3fa0eaaba5bb9073f1f5a32fa064ab59ab2f230a1e86efb432d9d8"
    sha256 cellar: :any, ventura:       "e454945cc2ca007d6c030f75389380aa3892183bf9214181c98b5949cc3ecddf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on xcode: :build # for ibtool
  depends_on "libassuan"
  depends_on "libgpg-error"
  depends_on :macos

  def install
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

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
