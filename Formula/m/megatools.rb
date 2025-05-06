class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://xff.cz/megatools/"
  url "https://xff.cz/megatools/builds/megatools-1.11.4.20250411.tar.gz"
  sha256 "f404ea598c9c5a67a966a007421945dc212460d673fa66bea44544fd82f8e7c9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://xff.cz/megatools/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "dedf753291d155903aea83187d4623a4d89e5b446221fe3876ff0b2adb4b97ee"
    sha256 cellar: :any, arm64_sonoma:  "f51bf27cb6af48490aefd72b8270266c297535abf1eeec4bf5312138931ae174"
    sha256 cellar: :any, arm64_ventura: "0edb1ed78ce72f15c4298581d29d9bc916cbdd39ea4584fb7cf232cf97b87dfc"
    sha256 cellar: :any, sonoma:        "74ed6b7c70b424092c8d0c88df0c74b56c8a413950f2d42e96b4399cdb581aa8"
    sha256 cellar: :any, ventura:       "bdcf5c5258307e845a9adabc6f46ebdf008c5cb9249df6e342029d32779c554f"
    sha256               arm64_linux:   "be8366823801f4988a542a3b663238c182f3e5ce724f53e88a68c2da914bdf60"
    sha256               x86_64_linux:  "0227d05b62821cba64ad74219460d7a58f3e44a8f6e0320ac335252a6deabf5c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system bin/"megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal "Hello Homebrew!\n", (testpath/"testfile.txt").read
  end
end
