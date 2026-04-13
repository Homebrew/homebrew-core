class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.14.tar.gz"
  sha256 "8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e8c95f4f09ec9349d195a5f3ae9fe7bb2fbf8db26e85c9e35a6c9486a067a673"
    sha256 cellar: :any, arm64_sequoia: "8ee88352b7074345247d1208d9033c496787074cae517a8dace2d1e6f19c1956"
    sha256 cellar: :any, arm64_sonoma:  "a8771c1c125e8aba500f940d688009e616a3f0f1d9369794c954065cda97b808"
    sha256               sonoma:        "e45b792ac8ca0ade286842b7ace8c8f4b2877bab1af410df5f8fd9d1fe7a3f2b"
    sha256               arm64_linux:   "02d0fc79f3aa20f18d76029ed09e3f3669a134e2687507ee64b151b7e74028ae"
    sha256               x86_64_linux:  "ba94938ff24cbe9dcc373d7bbd4e6a4e58367ff2ab0b54a44eab9aa65b45e5a9"
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
