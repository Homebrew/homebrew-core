class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.3/libdvdcss-1.4.3.tar.bz2"
  sha256 "233cc92f5dc01c5d3a96f5b3582be7d5cee5a35a52d3a08158745d3d86070079"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3a1da9ea4618f10137277bd109cc5d1c74ba3d82a2dc45f34370e1c389d8eea"
    sha256 cellar: :any,                 arm64_monterey: "c96a2adbc32a57e271a9a91d338571ab9b0a6524a95e3fe48270dd5c4a277b21"
    sha256 cellar: :any,                 arm64_big_sur:  "ef10943948da31c0015eb558758fea572963e381c13c203e79ee2169a826731a"
    sha256 cellar: :any,                 ventura:        "8ebe4191446d0808caee8a4cf8796e16dbbf075195f51683fc55aaeb1b5c9a6e"
    sha256 cellar: :any,                 monterey:       "cde7ea8b386ddf37ae4ec4b0901ba70583e5bff84d6bea9624a7064fef11b6a8"
    sha256 cellar: :any,                 big_sur:        "6410e6fd033c0145e2d6d4676776cc4f4c20cf540836963d74a16788c842a7fd"
    sha256 cellar: :any,                 catalina:       "b5915184be3174c64f03a0895a9ee71dc8baac9dcd5bf5e904977890ccbba2ed"
    sha256 cellar: :any,                 mojave:         "786743340aeae4fde2966f29bb0457123b529c42c5cbe52609ebdaad447b7280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3979306018ca60bc17dc7547699ef716342c46c1e755ba15d53f6eb9ac92dd"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdcss.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
