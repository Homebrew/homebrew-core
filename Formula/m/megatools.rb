class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://xff.cz/megatools/"
  url "https://xff.cz/megatools/builds/megatools-1.11.5.20250706.tar.gz"
  sha256 "51f78a03748a64b1066ce28a2ca75d98dbef5f00fe9789dc894827f9a913b362"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://xff.cz/megatools/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7217cae7f353389333d5f34a1dfbf0d5327372d0a869641a6f38a305a0e2fa42"
    sha256 cellar: :any, arm64_sequoia: "cbdaf47635fdec1fc36736de8b84d3a96d9eb83da463f0db512d138464009e2f"
    sha256 cellar: :any, arm64_sonoma:  "b6f04ece0c4f9db9b77383d8bbf83497f83108f64c94db171a7841c7311c7cf0"
    sha256 cellar: :any, arm64_ventura: "ece0dd5f77f6c087e65c8ea1a78a770a1d1fbeb4fda0f0271cc89b107fce63f7"
    sha256 cellar: :any, sonoma:        "c95b1c27bf14bccfb31ea2ea00540910a81b00861176b2facc32ae1d392628ca"
    sha256 cellar: :any, ventura:       "134758d6274b2aba59587c780f34b60b7ad7efa36e54c9ddb5a558f3e8ad43a7"
    sha256               arm64_linux:   "3cf9bf34c4d780c22dcd0aed0d34d5d9f3ee3f1df79fd96c2db62f07f2054147"
    sha256               x86_64_linux:  "bb702e9c4d883d99115f1003bac6dc09f0717ee64c9b52ca50b5e91a36d4cbe0"
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
