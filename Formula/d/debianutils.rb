class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.16.tar.xz"
  sha256 "eeb069c2639906f4181214dd1c4e448bc825229b0250ebf66f69c7344e8aa1e0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b59212632cd53ab06afedf75dc59751ae50ce425decd96b04c26e4ee4100c1c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5204898c7b6c40548accfd551c0f5165802de2860737929fbdc94253ba7b31a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5b0d14525f553fbe3711c4a149bed299911b3288238a7d522adaf3a6764fb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "72c456fbe197360e726e913bd92a4120cc666d1613a64945d3b7ac5e71366a33"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6c12a52d693500bf93a5ae97c8109f0ae026a16fff8f7c7acebadbfb6bca0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b451ebdd1c2f5e53b3e524936cef6320d9f197a22c869cdb0704dfd434cbcc75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60907a250af416dc6012f948e8abc458a204b58bb52e89d804d4af0b549ddeda"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build # for libintl
  depends_on "libtool" => :build
  depends_on "po4a" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"

    # Some commands are Debian Linux specific and we don't want them, so install specific tools
    bin.install "run-parts", "ischroot", "tempfile"
    man1.install "ischroot.1", "tempfile.1"
    man8.install "run-parts.8"
  end

  test do
    output = shell_output("#{bin}/tempfile -d #{Dir.pwd}").strip
    assert_predicate Pathname.new(output), :exist?
  end
end
