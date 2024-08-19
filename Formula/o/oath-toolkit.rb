class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.11.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.11.tar.gz"
  sha256 "fc512a4a5b46f4c43ab0586c3189fece4d54f7e649397d6fa1e23428431e2cb4"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5e6c673c9e2448fc86f6c8ae7830f403e4fc3195ad4d0296b8e9f66b13043ada"
    sha256 cellar: :any, arm64_ventura:  "995299804b377b1cdf080c9b21a5cbf99f3f5f5dfaf37e0f11129a9f51da1b38"
    sha256 cellar: :any, arm64_monterey: "95c1c32120d3958f4a257f20899fd6e0872efac1d822be4f537bd13f78773aa9"
    sha256               sonoma:         "52ced249f4426c8ecbf58f0509f17ed3e597491de1b7c299789056965d16d44c"
    sha256               ventura:        "c7560f0206fbac58cbda4e2e1ab324c1e5de227f71825a6527270185c41d58b3"
    sha256               monterey:       "a71c5889889ac62f287d31a929921c82e7af9c0d2bed738d76a481dad42c4b50"
    sha256               x86_64_linux:   "4e9227d49df3791de714e4e107034ba47b5207e7ec202d089e43c423231bfb64"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build

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
