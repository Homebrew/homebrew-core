class Libiodbc < Formula
  desc "Database connectivity layer based on ODBC. (alternative to unixodbc)"
  homepage "https://www.iodbc.org/"
  url "https://github.com/openlink/iODBC/archive/refs/tags/v3.52.16.tar.gz"
  sha256 "a0cf0375b462f98c0081c2ceae5ef78276003e57cdf1eb86bd04508fb62a0660"
  license any_of: ["BSD-3-Clause", "LGPL-2.0-only"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ab0c5ad41cb17f93a5d9b29ad4d64f6e1be2fb6f1c76bcd7db04b8ded60549e4"
    sha256 cellar: :any,                 arm64_sequoia:  "1a93beeb32954c2c1ce2bb4939c32f1940ec9491ba342ca594fc472bd01852b5"
    sha256 cellar: :any,                 arm64_sonoma:   "9727b705814070058ad5dfc93f33ddb542399e2bd63b09518ce0b779c02aeedc"
    sha256 cellar: :any,                 arm64_ventura:  "c2b3670c3da394419feff4b38ee185e150615479dd3cce7bf02cc2824e461365"
    sha256 cellar: :any,                 arm64_monterey: "10ca3676025de4d242130feb71200c95a131fa4f28d8201089f0471c2092c0a0"
    sha256 cellar: :any,                 arm64_big_sur:  "5b497dcb9a7aea40f94c0b20cd3c8616d5c3774153286e66bc5ba59e2510131a"
    sha256 cellar: :any,                 sonoma:         "51d457af2187861576522c3a4bf4d9dcd092bd6626b1e9f838a2f717330ed32e"
    sha256 cellar: :any,                 ventura:        "6f63d37fe5d6269eff73a52643932f5cc3c31e10ad9d6fefc90e51244f4ab689"
    sha256 cellar: :any,                 monterey:       "34627b18050d2acbef4503c41e52ac8c3f70443c46fbf18aa9d2947e0f43664f"
    sha256 cellar: :any,                 big_sur:        "90d98eb9831742490c631612df419d83d7c0e2495dab9bc5ddec36ba4e67d8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2fed59ad000ff8d08665d2ea43a4b4d997fca1fadccc470c58290d72bdc9259d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a55f7da0eb9e5afb600e861bb089d7f7a74d393b4c29c9d7d9383c75a717883"
  end

  keg_only "it conflicts with `unixodbc`"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iodbc-config", "--version"
  end
end
