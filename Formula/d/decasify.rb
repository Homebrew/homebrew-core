class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.8.0/decasify-0.8.0.tar.zst"
  sha256 "1d35006ffc8bdc7e01fe7fc471dfdf0e99d3622ab0728fc4d3bb1aea9148214e"
  license "LGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67f3d8fe3d2b2075bd394ce73e74212d34dcb0ee895d47a8f7dad900713e57de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de0e5675ed1a3e5f9efce89db8c16fdd8786e196905ee844207d91648eed3648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48107a2056c18adf1ba70fde014d373465f7596d30d04126f0697f12e4c9a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "31cb66b6d9eca38f3b9b5910414193c0bed89c706c2abafbaf607aa2f465ccfc"
    sha256 cellar: :any_skip_relocation, ventura:       "47646a4c162f98a43fb12b95e4f4584754ef66568b538c242c30087d8ffe76fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43c42908bc43fa322a6761703a4dbe5d364593c5d440f4e67e55c271018688c5"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
