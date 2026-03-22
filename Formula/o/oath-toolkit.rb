class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.14.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.14.tar.gz"
  sha256 "8b1da365759f1249be57a82aec6e107f7b57dc77d813f96dc0aaf81624f28971"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be69513c03fa1a31c6e590fd6873033505f82612471832e327d55cfa55ae822e"
    sha256 cellar: :any, arm64_sequoia: "031067b5c96b2a25e386455e275a1e742275e079bebe392579cfc67c86508e8f"
    sha256 cellar: :any, arm64_sonoma:  "fbf83d68bec1c112f46fc73fa20a697f374fb28dc318c3cd03abbed5fbb4274a"
    sha256               sonoma:        "1eeb6226466d3aa467080421151f80284865f7abf8be8b93fe2b320c3408b3c2"
    sha256               arm64_linux:   "f8175b382aa6a5cbcfac359b445da5e60739fc745dce2ba19789085b98fb9869"
    sha256               x86_64_linux:  "ae317354c3e8fd7ebd807e9f50e27cc2b5e06d9c3059500d5a49b0abf93b170e"
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
