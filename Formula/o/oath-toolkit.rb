class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.14.tar.gz"
  sha256 "8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 3

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e3189a79283536902ac625eae9bb2b2cf08e94efa223b9c1309f49644c3f916"
    sha256 cellar: :any, arm64_sequoia: "5df29b142ddd79a981d26641fe1407185ec13053038e45f518ec0cf2db99b13a"
    sha256 cellar: :any, arm64_sonoma:  "3eebb109d310fa1a06d6b3f895dc6740651bb2079fa4fb160140c7ebb07f8094"
    sha256               sonoma:        "a3a81851ae782909c7ea9c6d2fd9634e8154d1de774da00714b6601f24102711"
    sha256               arm64_linux:   "85e93423745de435c7646aa6b9ae12edbaa4e9196ca43c482b6fd3cb4e763f32"
    sha256               x86_64_linux:  "6b892babe12808ff3f8470831689114f057b71c4c7e37ccbbee387920257cfbb"
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
