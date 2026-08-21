class Freesasa < Formula
  desc "Solvent Accessible Surface Area calculations"
  homepage "https://freesasa.github.io/"
  url "https://github.com/mittinatten/freesasa/archive/refs/tags/2.1.3.tar.gz"
  sha256 "dc4fe377352569299d69329d9ded2f141e527da325960b20d2e30b5335c2b3ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e99b8ac2d7a1662531a39c4aaa741ee30209d386aa985c1aa007aa1f81f08753"
    sha256 cellar: :any,                 arm64_sequoia: "d1111081344ac1f897843cbf71d1f61143948097c70de7b2bb815264c99e923b"
    sha256 cellar: :any,                 arm64_sonoma:  "b7d36d3748640472fcd7fc357e50839df9305242384f8b197ded7f254ef0e199"
    sha256 cellar: :any,                 sonoma:        "a272197b6d73c572b70c94a79d02e085561e94f22839ee474340cd0bd9b9fa0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "433e178d16d2d4612ebb7279379a7d5bda63351c2953ebcb3445e6a42786c3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c1c32cf2ad2cd5b37eaf71a5fd45b7775a76e42b4e9954a4a6252c07ecc68a9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freesasa --version")

    output = shell_output("#{bin}/freesasa #{pkgshare}/data/3bkr.pdb")
    assert_match "RESULTS", output
  end
end
