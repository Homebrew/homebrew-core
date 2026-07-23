class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.7.2/hamlib-4.7.2.tar.gz"
  sha256 "ae1fcf2dbc80ea0786ea8f047b09399c3f7737d1930442f61a031708ed33e88f"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5b3121253c6c02cb3e4408c34ecc4ad5d0e542df2370b4d62a945c080a68fdcc"
    sha256 cellar: :any, arm64_sequoia: "0272727195c00b85ac9991545e3a86ea1d1c84c2da785a1573879d10d59db69f"
    sha256 cellar: :any, arm64_sonoma:  "45a87a2b474931b39d2e8407ef931b7753681be7d992536acbf9c71b9e54bc29"
    sha256 cellar: :any, sonoma:        "fba407c9ce0e3a36dfe739e5df61ee05c4d437d350a851a6b9b1d78fa1ff6f8a"
    sha256 cellar: :any, arm64_linux:   "e4b13e3f8b5c3721fc3edceb8cc75310e9c247ebba62399cd6097facc482e1ce"
    sha256 cellar: :any, x86_64_linux:  "30656fd2ae24e51a21f81b28ca3e47f1d5b9d657a8ec67b5a606f1d61fd0a2d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
