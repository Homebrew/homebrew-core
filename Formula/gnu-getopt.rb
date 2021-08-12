class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.1.tar.xz"
  sha256 "8e4bd42053b726cf86eb4d13a73bc1d9225a2c2e1a2e0d2a891f1020f83e6b76"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae59371d0bc1aa629882dda55f05ef741a4b5c1f312a0e624a708c0dc88998c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a7c4e963750c612e235839a8ed7c18cfa5d080b067bb2db98859d5c8b8b5aba"
    sha256 cellar: :any_skip_relocation, catalina:      "b4d0a6f8a244e4f4011cc30a536e2959c94505f53de315bb470853d23a6f53fd"
    sha256 cellar: :any_skip_relocation, mojave:        "6fbd596ad1960a40df146c566258ebeb01338f2ae80b03134cd64e47bd7cf839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b0a061947671bde9e7c1437a6fcdd9d501562a28a3dcf8c3da61cca8e6a4f7"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

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
