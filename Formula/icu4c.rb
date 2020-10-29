class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-68-1/icu4c-68_1-src.tgz"
  version "68.1"
  sha256 "a9f2e3d8b4434b8e53878b4308bd1e6ee51c9c7042e2b1a376abefb6fbb29f2d"
  license "ICU"

  livecheck do
    url "https://github.com/unicode-org/icu/releases/latest"
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "2d1e91b5127f66e7941790c004817c94c892725c88f84f1e4c37297fcbc0c72f" => :catalina
    sha256 "b6069459c78f18045ee922ce5cb5b235d4b479597d79c3c298d09e0de3d70794" => :mojave
    sha256 "0720bd47f020d5ca895ae79eb61623ed3c7de0d4c4f221613105f47147aec01f" => :high_sierra
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
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end
