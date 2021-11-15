class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/0.4.0.tar.gz"
  sha256 "83960c412a7c176664c48ba4d718e72b5d39935b24dc13d7b0f0840b98b06824"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "e2c59b901c06ae27cc3576cc279e6f3bbc546db4c4a461beda62500a4f58e35d"
    sha256 cellar: :any, arm64_big_sur:  "0ef2e1ec65b8dfd26c959c5511d645c239fb8ec29343c1785df52d6abbafd466"
    sha256 cellar: :any, monterey:       "5f186a90b7ca267f82e8516a3f0f057d052ad2fc5795ee5c6d2ce89ab562eabd"
    sha256 cellar: :any, big_sur:        "7a9331bddff426646291a13c0cde40ecc1399acc8a44db3073d6756d56ca5621"
    sha256 cellar: :any, catalina:       "c851f4db6bd4095dd61c1f4a2b192f39b21f05aa8c6e994b9f75d6f183e0bbb8"
    sha256 cellar: :any, mojave:         "e6edf87d690e5c17b32a04d0da7ffe6cdf185cb6273a23058c56373b62bd554d"
    sha256 cellar: :any, high_sierra:    "046e756acf6694ae9b8768c62981f807a93aaef52d175bbff7005a29bb23aa00"
  end

  deprecate! date: "2020-08-06", because: :repo_archived

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
