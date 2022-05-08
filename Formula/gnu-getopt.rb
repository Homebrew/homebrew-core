class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.38/util-linux-2.38.tar.xz"
  sha256 "6d111cbe4d55b336db2f1fbeffbc65b89908704c01136371d32aa9bec373eb64"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96d951b721c22830f976066f8704424bb065f1814fbd6d86fcd5f3996679db81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7185fed500da9746d2249185f6fdbb93a7d08dd85661c5699c768004927e010e"
    sha256 cellar: :any_skip_relocation, monterey:       "eee08bd48c1ad6adb71687db5599fe6d593769351d2cd5f9f1f2d485fc69c9b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4951cfe10db08f60f663b717a03a01be7a774ac717be30d19a2c36fdbb38c7ca"
    sha256 cellar: :any_skip_relocation, catalina:       "858025570517573d8254ee63717256cdfaea66def67cc0a5675a800deb0c674f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44292ce4da02a035699014bc56f714825399406ab8e3b9b5480a9e293a90af2f"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  # address `sys/vfs.h` header file missing issue on macos
  # remove in next release
  patch do
    url "https://github.com/util-linux/util-linux/commit/3671d4a878fb58aa953810ecf9af41809317294f.patch?full_index=1"
    sha256 "d38c9ae06c387da151492dd5862c58551559dd6d2b1877c74cc1e11754221fe4"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
