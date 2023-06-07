class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.tar.xz"
  sha256 "32b30a336cda903182ed61feb3e9b908b762a5e66fe14e43efb88d37162075cb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a25a9ee12cceed43085d92626a1268619c7198ef38add73abd873237b754de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df9bdc36257e33dc33c6f3785d1594cde0aac1e81806b9b7e2659d2e7b4feb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd9665ac14b832407a6ea353a5a0142491848417b3198b6871038a29ebcf50f4"
    sha256 cellar: :any_skip_relocation, ventura:        "dd9c73190ef0b2af8fcfe7107f8e99df44d4fd7cdb16c2428775e2a1abee02d7"
    sha256 cellar: :any_skip_relocation, monterey:       "b3db35769d97b8f07431fbb83777e423d15ce9471d97a60ce0a4f1ebabadcbbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1b3803d0efe078bc4dbe1f2817b2e8f9b6301a291dbc599089eb5a5c03888a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab20209c18ea3fb93140b90a43740129d3f3edb385c5745489a7a2fea58df65d"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  on_linux do
    keg_only "conflicts with util-linux"
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
