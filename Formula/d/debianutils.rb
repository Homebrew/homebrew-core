class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.23.1.tar.xz"
  sha256 "206c669cbf431da30904d4f9e69d049cb711714f5c137b66bf0b1f66d58710bc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1fea04c8ac4bf111d057bd45cd17ca5d0eba7685d5199f75abeb2815422633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91af649df8abdd648fd0c580ba027c1d56737f03ccf3a72f08e4bffa186d666a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d520cffb246aca0e57b7f4978d09cc72b2acd94329bfebca85a3c8cacbd7efd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9add44bcd5b8ac61b415615b6211213342c35757088ba210cc79eec8fdd7bca6"
    sha256 cellar: :any_skip_relocation, ventura:       "6da017c102bd1e59f1e97f39022c6b436d21574652a13666cdaf95a2c6787456"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef93592860adf70ef60dbf20b513c6b2536b405c35ca89fb945c52a2fbfc335f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ecc47e43cb418d91fbda426218d15c76ba71c39f5010e5942b012c5684a15d"
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
    assert_path_exists Pathname.new(output)
  end
end
