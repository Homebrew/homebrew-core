class Libdca < Formula
  desc "Library for decoding DTS Coherent Acoustics streams"
  homepage "https://www.videolan.org/developers/libdca.html"
  url "https://download.videolan.org/pub/videolan/libdca/0.0.7/libdca-0.0.7.tar.bz2"
  sha256 "3a0b13815f582c661d2388ffcabc2f1ea82f471783c400f765f2ec6c81065f6a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdca/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)[/"'>]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0737b7bd914efce32ae323ecbb5fca30b14b39ef31d704a482883598303518b5"
    sha256 cellar: :any,                 arm64_sonoma:   "f8040bc44c93b05569e5f2cbce08e3b2377bd2445c4f305c2fb49f63a22850be"
    sha256 cellar: :any,                 arm64_ventura:  "d7c6080f57c3de053cb1e94bfc535b783389d9fde51c1cfe6e5c0e8b0c5245d8"
    sha256 cellar: :any,                 arm64_monterey: "505dbd9ed35b7bede454672385472ed725d6fd84f15a984d3d3e1025725d996b"
    sha256 cellar: :any,                 arm64_big_sur:  "d20b5e52384fcbb0da4501eb109e3aac6be3eb6f0e6a8f09de0c61b2f3c83361"
    sha256 cellar: :any,                 sonoma:         "f0cf65d1a7c35c4f90798eb1522341a6f9441ecaaa62bb68b1b3afbd8194ec43"
    sha256 cellar: :any,                 ventura:        "09bb7d9235fe77b84f724ddeb66c7b2a54a6448a99741ad89368722b526ee972"
    sha256 cellar: :any,                 monterey:       "d3e058da247c2b2976a7c28da8102792b56cbe4abfda68cf6960f94961907ad8"
    sha256 cellar: :any,                 big_sur:        "123d7863f98b6fc1f56aaca440db706764b43c99fe1a5bd5286badf160f76d62"
    sha256 cellar: :any,                 catalina:       "d9c4b3a350744867f5782db738d25d1212b9be89449030492083364574f914d7"
    sha256 cellar: :any,                 mojave:         "594d6b26eb3ca16c3046ff2792de4f78a0f038dc94b1972c8827e86331a46fde"
    sha256 cellar: :any,                 high_sierra:    "f8ba469ce443efa0e9fc87b51a87c6b4d510bd3e7bb91ae11d1f91e99f760acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d7ec4a08990df38fb26a4c719e6bd669bd35e3e5e89d49d43fea007b74e3edf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "dcadec", because: "both install `dcadec` binaries"

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
      sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
    end

    resource("homebrew-testdata").stage do
      system bin/"dcadec", "-o", "null", resource("homebrew-testdata").cached_download
    end
  end
end
