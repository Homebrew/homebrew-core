class Proxytunnel < Formula
  desc "Create TCP tunnels through HTTPS proxies"
  homepage "https://github.com/proxytunnel/proxytunnel"
  url "https://github.com/proxytunnel/proxytunnel/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "edb33a74ba49e745b55b790f123366c8336729947225f4b5d816f1f90551ecfe"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cc4ec787e8432e1d2ca660da6a12c6fb3b5c3f7d9a5ba45d9497559ba38b500f"
    sha256 cellar: :any,                 arm64_ventura:  "4b8fc03744979dac682161da15fa8076b904a5b17582bc81588d61ac460c99ba"
    sha256 cellar: :any,                 arm64_monterey: "dd2e453c1f4c7066dc12a122453345abe43ea77a8d405c530600ad1fef10b780"
    sha256 cellar: :any,                 sonoma:         "22e300ce753b252dd49e225f0f6532a2d2b942681b5f83215728c40a09f657bc"
    sha256 cellar: :any,                 ventura:        "0b0e7b53fa09dedc6fd0d1f57151992da961cc66fde1ccc353399265db0e0233"
    sha256 cellar: :any,                 monterey:       "ca0729c5efb1753546e44dfa32b2d287ac254e70b74a5e711c545edebc7e2ee4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85b78dc09d5c849110d32f44b3276babb0649ee5a545ebb69d786de8bba4f6b"
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "openssl@3"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/proxytunnel", "--version"
  end
end
