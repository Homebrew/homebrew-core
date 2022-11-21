class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.4/isync-1.4.4.tar.gz"
  sha256 "7c3273894f22e98330a330051e9d942fd9ffbc02b91952c2f1896a5c37e700ff"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.code.sf.net/p/isync/isync.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04fb22e1a315723cc3ab4035656c3435998821be930a4df4d49a97cfaa586a4e"
    sha256 cellar: :any,                 arm64_monterey: "95afd09cb00be9960ded1846393a3ba9954d7e65dda8704dd6678ee31564d588"
    sha256 cellar: :any,                 arm64_big_sur:  "20bdf52bc6b10d073dbca79b20c6d7008d7639ad5109e20b98e7b05e1a5b8412"
    sha256 cellar: :any,                 ventura:        "14c0f8dc5fd3cc09516f12783542047afd01ecece5e6f45c452f65547db88e9e"
    sha256 cellar: :any,                 monterey:       "9fabb93ff8e3edacf208eccb77cc6e456eb52146839fb8df8f11fbaf34a1b118"
    sha256 cellar: :any,                 big_sur:        "42d8ad7a8728df819720a4a0ded2bdbbba86a1c730f4593a0659af9808637435"
    sha256 cellar: :any,                 catalina:       "bf1041694107d4d5173b2a79eb447a1ef568d6ad79783ede8ef5ac2157d78102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28a71e46d89483ffde37b91ed00f9a7a60933c184db724c6103fee86392bdad3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Regenerated for HEAD, and because of our patch
    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_bin/"mbsync", "-a"]
    run_type :interval
    interval 300
    keep_alive false
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
