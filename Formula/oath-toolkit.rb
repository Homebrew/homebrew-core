class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.7.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.7.tar.gz"
  sha256 "36eddfce8f2f36347fb257dbf878ba0303a2eaafe24eaa071d5cd302261046a9"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "78cfac4a520dd81fe758a5d55d0f05e49cfff2f91abd9ed4376922f54d8641bd"
    sha256 cellar: :any, arm64_monterey: "916966e662d84e352bd54c21a32c0c3ba5986fe1a9711a1292f34c3acee1ff56"
    sha256               arm64_big_sur:  "bde1ebd951548431e0a8a1a654a980a0e0d1cf189a65debc9156e0b55033fde1"
    sha256               ventura:        "5bde0b71a6ba32c4aa622adc290cd3abf0144d1780c0985bc5cde00c5f2f5fbd"
    sha256               monterey:       "141152f0e04f2805bc79b207c2572d42e725e459343e7353a6d0da115b5b6916"
    sha256 cellar: :any, big_sur:        "44766968c6215e02f4456375f9f1574cf72aa813ae08eb2bbac60888d24c1c60"
    sha256               x86_64_linux:   "dd6bb67e9c5a9f4f46dafd67a84e58f0a36cf1be54a98fc266317b5b317fbb78"
  end

  # Restrict autoconf, automake, gtk-doc, and libtool to head builds on next release.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc"  => :build
  depends_on "libtool"  => :build
  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  # pam_oath: Provide fallback pam_modutil_getpwnam implementation.
  # Remove on next release.
  patch do
    url "https://gitlab.com/oath-toolkit/oath-toolkit/-/commit/ff7f814c5f4fce00917cf60bafea0e9591fab3ed.diff"
    sha256 "50a9c1d3ab15548a9fb58e603082b148c9d3fa3c0d4ca3e13281284c43ed1824"
  end

  def install
    # Needed for patch. Add `if build.head?` on next release.
    system "autoreconf", "-fiv"

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
