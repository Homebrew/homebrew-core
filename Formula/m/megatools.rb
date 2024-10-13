class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.11.1.20230212.tar.gz"
  sha256 "ecfa2ee4b277c601ebae648287311030aa4ca73ea61ee730bc66bef24ef19a34"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia:  "85e234e1bbec028219e914ec7b0d03e07fbb14bcf336b1bd46a4b08340eb37f6"
    sha256 cellar: :any, arm64_sonoma:   "b3845c4b42f560ffa78ece64807be6ac5e829b2e2841ce5fee149052d24e5efd"
    sha256 cellar: :any, arm64_ventura:  "2eb61f7ef9e0c71c3eb0d1b6520e2b99b2f0aa223e2f0bb0a53a3608581718a6"
    sha256 cellar: :any, arm64_monterey: "c6812e8db8d5fde82501424bcd6df3483965f10c70a71149f037152f5f36f705"
    sha256 cellar: :any, sonoma:         "e7a64a9b5e2b99b3b77a0cdab91b485b1d0cdacc57930cf5d705219f22b4de5f"
    sha256 cellar: :any, ventura:        "7b3b7420ba80bb643a085c7499dacd677f3dc56e307a3c4d1d55f45f83825940"
    sha256 cellar: :any, monterey:       "26e2e1584ae817ded14bda61288acfb220c4ec49026c522475ee8612a7ab7a45"
    sha256               x86_64_linux:   "107566f078fc8ea1b7c586e8a7ed5a217afbe28c830b6d55e676cd639df62913"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
