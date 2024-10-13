class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  license "LGPL-2.1-or-later"

  stable do
    url "https://github.com/adplug/adplug/releases/download/adplug-2.3.3/adplug-2.3.3.tar.bz2"
    sha256 "a0f3c1b18fb49dea7ac3e8f820e091a663afa5410d3443612bf416cff29fa928"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "05138760d4846e2af8f5e13a0b2ddda09e700f1d9a0e20f950a81e3efe8b5c94"
    sha256 cellar: :any,                 arm64_sonoma:   "514028f94c34051f59df4b74c32ff78fc84b64d0fa18d0c5b4f8b43ef62a4283"
    sha256 cellar: :any,                 arm64_ventura:  "88af10e2c8f0262b54a4ce6f71ba1903e13abbeafad1ffd2d6612f44c140e7fb"
    sha256 cellar: :any,                 arm64_monterey: "daa3f1233e27cf292d303d51e3c6e3bdc423645ba71469ef9107af0df3f4f56a"
    sha256 cellar: :any,                 sonoma:         "4762b417de9a58d94b75282382f471279b5dc20996bbf8df2b400c01af3c62e0"
    sha256 cellar: :any,                 ventura:        "3e2445d7a6e2abc018a5e9dabaa17fc4b96653dca6c034522f732e7b7a8c3808"
    sha256 cellar: :any,                 monterey:       "f5219a73107c5f947afd837afe02f23a1cafcc4611efae7a393f11239f252509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec7b64b6c3b963b8fb6fc6a330cd7ef305af5f76246c8415fa67f4cf7e273a12"
  end

  head do
    url "https://github.com/adplug/adplug.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libbinio"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  resource "ksms" do
    url "http://advsys.net/ken/ksmsongs.zip"
    sha256 "2af9bfc390f545bc7f51b834e46eb0b989833b11058e812200d485a5591c5877"
  end

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("ksms").stage do
      (testpath/".adplug").mkpath
      system bin/"adplugdb", "-v", "add", "JAZZSONG.KSM"
    end
  end
end
