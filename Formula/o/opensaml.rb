class Opensaml < Formula
  desc "Library for Security Assertion Markup Language"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/Home"
  url "https://shibboleth.net/downloads/c++-opensaml/3.3.0/opensaml-3.3.0.tar.bz2"
  sha256 "99ee5091a20783c85aca9c6827a2ea4eb8da8b47c4985f99366a989815d89ce8"
  license "Apache-2.0"

  livecheck do
    url "https://shibboleth.net/downloads/c++-opensaml/latest/"
    regex(/href=.*?opensaml[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef3bcbf1661bd845ddaaf679bc4ac1c97be7322e540dcac03eea07c6e4f0870e"
    sha256 cellar: :any,                 arm64_sonoma:  "e271048b419d93cdce4c3b93c1e0e275fb089e9751d29145670f8b4bd757c1cf"
    sha256 cellar: :any,                 arm64_ventura: "0124f112da5200068af7735cf823f0b49c2c7cf4f71de7a1424f63096a5a0f4e"
    sha256 cellar: :any,                 sonoma:        "c9dd4f9976072123348f5523c303b195fd1e2d846312b341db00bc2585c14c03"
    sha256 cellar: :any,                 ventura:       "1642d4e0c2ee412a24f2003c883bdf62e03d142dd7882474f6025d85a91a21d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "252f721596bf59190b2acb8b37ac0aa8b77aa47c8c9fa7de236bdd35a5217a13"
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "openssl@3"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "see documentation for usage", shell_output("#{bin}/samlsign 2>&1", 255)
  end
end
