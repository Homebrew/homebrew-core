class Icu4c < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-68-2/icu4c-68_2-src.tgz"
  version "68.2"
  sha256 "c79193dee3907a2199b8296a93b52c5cb74332c26f3d167269487680d479d625"
  license "ICU"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f1a3de6838d7b7676e74dbe97f30bbcb68e6e20d4f5c49380c4cd98b926cdf4b"
    sha256 cellar: :any, big_sur:       "ba2fd8c7d37025c93db6b03cb831bf414f0859a617c7ef179782a7fbf965a9d9"
    sha256 cellar: :any, catalina:      "fdc2f15705175478dc16607f2d457c0667758e2580beefd67d4d33feed7f5af7"
    sha256 cellar: :any, mojave:        "c83bf88927906242e2d7e185619ee3f449c2b1d39adfd74b7449775aa15031dd"
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
