class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.14.tar.gz"
  sha256 "8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 2

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "941d3e0e1bb7a1f58b83bbd5302b931787dad67c3acf4624d013370d6e1f6912"
    sha256 cellar: :any, arm64_sequoia: "ff156d849d6dce0e6ff29b4d435e0938902555c976efbb2db35b816ccc4d55ae"
    sha256 cellar: :any, arm64_sonoma:  "5a8e8b84c8722bcbce58b8d6731829dbbf288dced5aca178dc8c8c9667318c05"
    sha256               sonoma:        "afeb5f984e571f25b8fae8afac139c549102ab2d7cf541578f261b8efad39800"
    sha256               arm64_linux:   "7e80b8d9c95a850675f96044eb9236f5b4abec087f2c885c59920f7256a01a35"
    sha256               x86_64_linux:  "79f94883b4a5cac2b036c5b0a0ab4489db38c196e631c18d5249346f0e4db1fb"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build

  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
