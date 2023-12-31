class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://packages.debian.org/sid/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.15.tar.xz"
  sha256 "d169cca3ef206f5d26e4bc061581d819ec60eaf5dba3f205ef17fa404ec80398"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://packages.qa.debian.org/d/debianutils.html"
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3034cb3bbc8a4dfe5d99a35de66592226076f03a9609f6f8134ac1de40871595"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02255dda21ef54af53867281389ac49adba8c8231045f8bc28a44bc87f8b85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7502716dbfa60382e61132956ec60b7a49e2a9328332088f1396b4040d1faf01"
    sha256 cellar: :any_skip_relocation, sonoma:         "72d9601d13a3613fb898f6abb7babc2e5706c41b4bb2a90f47d2bb48f7438cee"
    sha256 cellar: :any_skip_relocation, ventura:        "972d5500f136291811add737be98bd65a4a524dd87c8797d989a8fd9c7f0e3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "1345e8a421ac9aacaa17b9606afd327aa024d9b3ecab703104c46434210d9c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8333c3f959871b858fd333c568eb46f384a22b37a9f835d8f553f4e966e4a749"
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
