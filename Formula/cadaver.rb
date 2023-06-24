class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.24.tar.gz"
  sha256 "46cff2f3ebd32cd32836812ca47bcc75353fc2be757f093da88c0dd8f10fd5f6"
  license "GPL-2.0-only"
  head "https://github.com/notroj/cadaver.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f31ec5eb5056e09d4b8a22a2323fb2bbe3c8c15ea89be69429382c00ec534d3c"
    sha256 arm64_monterey: "4ffec4d1167cb17f80cb63c4142909b6f208cc653518cee7f46fb7c1f270e192"
    sha256 arm64_big_sur:  "859215276f7fda671ceee3b7908772d84fccd12873e6bb6cac0f90c50982cbcc"
    sha256 ventura:        "276617de9ff7b225421e56658cba86766a180a42f6458586b7e0903be7945c2e"
    sha256 monterey:       "72eea3f287da7f77740b72db463cdf967c355a4044d0730150d637145d6be312"
    sha256 big_sur:        "240a41ea5b71aa144bea0fdb28b6233130d5368e8a221171eaa7bee24f5075a6"
    sha256 catalina:       "da94dea10afd90e1d0e41f24d4319ea006bf909381de2c2379c3144374c3feff"
    sha256 mojave:         "a232491b47135718f6cf65d00954099d92a43f5fcc6b01838a676faa77f2ed13"
    sha256 x86_64_linux:   "03a8734a293f551585c100ce10389aa2a66222ab711d9c80b7300d139eb8546b"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "neon"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args,
                          "--with-neon=#{Formula["neon"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end
