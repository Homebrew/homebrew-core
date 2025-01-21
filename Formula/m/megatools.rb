class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.11.1.20241028.tar.gz"
  sha256 "3632135a23aa737950e74183199eb23d4e44461ca4221842717225fb31527a4d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a148a907f62ef0d56c1b37fb6e4c353b98f8d2bf70c3edfea47c2748436038b4"
    sha256 cellar: :any, arm64_sonoma:  "52dc8dc0be48c9892b452a93528f5ca3367ed388586ab2e3b1d8163b6037e8b2"
    sha256 cellar: :any, arm64_ventura: "b9e5952709570af2516206bf02281cd5bc8213010b780f3c55e60d86e6fd59e7"
    sha256 cellar: :any, sonoma:        "53486056197b1902084319e1107bba9831201bbf4c0486c87f9a9d966704c703"
    sha256 cellar: :any, ventura:       "f273dc42b8873611dd8ac1a70013438749f7bb406d8a506b8fb8bffd01686941"
    sha256               x86_64_linux:  "08d6b16aefc7d5691364a22fe12f02f34a14302ab0f0c44695f6e29bad5c7e56"
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
