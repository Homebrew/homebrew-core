class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.14/axel-2.17.14.tar.xz"
  sha256 "938ee7c8c478bf6fcc82359bbf9576f298033e8b13908e53e3ea9c45c1443693"
  license "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2e4f284dc20b918521e8493a25f90dc1ec4f70e1475e548a1b04ccfa967a130"
    sha256 cellar: :any, arm64_sequoia: "95c51635ca58e485bd24471f4586bb1588a83abeefd50061bfb24494086696d7"
    sha256 cellar: :any, arm64_sonoma:  "33ccc3f5be77891efca3ce004f122cc494db614255e445fd721a6bdc9433a30d"
    sha256 cellar: :any, sonoma:        "8926c7626c602becabb002607665fb5680aaeb113469a2be0d307ef2a84fb902"
    sha256               arm64_linux:   "66b10f06213d7853d329bbe6550cac344cb5c0ef2e80b9288d5104b4204df8c7"
    sha256               x86_64_linux:  "5e36485c13d0c6d2d3ec965dae2d9d2e87cb8f4929d7b8a9c1cc4115eda26012"
  end

  head do
    url "https://github.com/axel-download-accelerator/axel.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "txt2man" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
  end

  def install
    if build.head?
      ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"
      system "autoreconf", "--force", "--install", "--verbose"
    end
    system "./configure", "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_path_exists testpath/"axel.tar.gz"
  end
end
