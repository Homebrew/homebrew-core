class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.17.tar.gz"
  sha256 "438cbd4c6673a9e156ef9a4793540762e8438298063cac019a45f55ac577872e"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "13806678f331d5cf443ab26e4190b6b79de0c33541cc083ee33396a9361cc71f"
    sha256 arm64_ventura:  "9f1bcfe7faec9233c76de1a61181dc65860517a30f44a73613132722c99e91d0"
    sha256 arm64_monterey: "b57f8f12b1cac450538e777edb612638d8e30ea0a0fc364fd4f6444687bae5d0"
    sha256 arm64_big_sur:  "d6c5799db7ad777b686f27c853b5122f351e3e38fda05be0b491fd34ae0f308c"
    sha256 sonoma:         "439f359bb786b9d31944c96e88a084c4d305a0dd218af2cd69724d808ea02e9b"
    sha256 ventura:        "66a0a8386caff8134b7bae76beec4525ac4c5529b708c24718887e09bf15fbcb"
    sha256 monterey:       "062c063380fc216608dac9f3b83bdd9c51ad7e2766d3e87ea32c6993ffaee3e9"
    sha256 big_sur:        "5ad79f3c3a94e815b938604dedb32356181490963037d4165230c927bb5989bf"
    sha256 x86_64_linux:   "d164474207477be359c00de33397dd7f6b609409f93d54b984885b4fee045000"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "cups"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gnutls"
  end

  def install
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--without-gui"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
