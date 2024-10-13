class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.20.tar.xz"
  sha256 "dce8731adee52d1620d562c1d98b8f4177b4ae591b7a17091ffe09700dbd4be8"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "12a4a59b6bc17744ec2040d42ea66ed78379805958487b11736cfab8e2d7b27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "265449156e8ae02d20e994717cb71f3b62292644638bff4456913931e0a8399b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9a83e1b1730070bd6f656ed2b41d5329b808630c9ada3c705658befca9a4306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6ef403303480663ad615b72af86671bd834facf8e92cd45502eb851b872a6b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "59383400f34140c70ac48a03829442c3e8b0cc727c4af6ccab204f303b77cb70"
    sha256 cellar: :any_skip_relocation, ventura:        "8d368475eb11dd898006e67d77783c7f8c928df3830348456c50c963157a3123"
    sha256 cellar: :any_skip_relocation, monterey:       "36b1bc882b496edcf81675a807d20b92ecc3a7fdb6b5aa8ecf9d9150f1becfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ad4cd0e4299a08ef893e6420a6dd9c9b30db187915cf49625c270640a73462"
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
