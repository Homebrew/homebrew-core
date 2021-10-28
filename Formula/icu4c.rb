class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-70-1/icu4c-70_1-src.tgz"
  version "70.1"
  sha256 "8d205428c17bf13bb535300669ed28b338a157b1c01ae66d31d0d3e2d47c3fd5"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "43cf787a35559b90597db8e1aaba95dbeedb84b1ee3d2e942be8938ae618724c"
    sha256 cellar: :any,                 arm64_big_sur:  "c3c22a25dd864a6494d2371bea6b8b9d5e49f8c401b2f6cda00f4c349f57e975"
    sha256 cellar: :any,                 monterey:       "321592eb1aebb7c6edc7a5e91393598725ebcc63362f059072b993c27f3bf979"
    sha256 cellar: :any,                 big_sur:        "f124a30b9ecb4bfe61cd8ab5e46d58877fd5acb319360dae446648730a4b3ad8"
    sha256 cellar: :any,                 catalina:       "8773ed472307dff9a522558503e0f12aa77433510e856136946a558ae3087c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f36c9e1047fb1a9e1f1889eae2ade68d6518fb847a90e7947cc87ca94512ef"
  end

  keg_only :provided_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system "#{bin}/gendict", "--uchars", "hello", "dict"
    end
  end
end
