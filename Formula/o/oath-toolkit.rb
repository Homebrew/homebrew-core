class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download-mirror.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.9.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.9.tar.gz"
  sha256 "333ac831c8f1a6dbd7feb897339bba453ff34d3b0f4cfaa6b5a20dba55c8e985"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4ba53487d4db148b93cdec180246724677658839c24f270cb743bc1254319c3c"
    sha256 cellar: :any, arm64_monterey: "0ad47728dacdabbffd46306cf1f40f61dc54f43f568c39683e82a71e45c9f5f8"
    sha256               arm64_big_sur:  "57f00f50aade24072074445fb8b33f9600b71d5cc3ac286db066fce8f47f12de"
    sha256               ventura:        "b7796f8492f196b003ad73656fd7dd1597da02b5d433d24ded8e70a5d223f632"
    sha256               monterey:       "e4ca111ca23d31e861e3cd4fb76a8f2542dd7a4cf69cd1cad36299828a0a6d48"
    sha256 cellar: :any, big_sur:        "21f1e0df5c03224470ce39346501241f45e0195f486fbc36cfedbe3aa50871c5"
    sha256               x86_64_linux:   "627a86bc837b0d8fa0acddfb917cc9420d2435a3ef0e5516f2a2c0d05e54b748"
  end

  head do
    url "https://gitlab.com/oath-toolkit/oath-toolkit.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"  => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
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
