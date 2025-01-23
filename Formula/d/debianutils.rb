class Debianutils < Formula
  desc "Miscellaneous utilities specific to Debian"
  homepage "https://tracker.debian.org/pkg/debianutils"
  url "https://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.21.tar.xz"
  sha256 "0053dcfd89e5c7dbfb2632450c00af6b8a646eeaaf185bbc8f2915488f994fe5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?debianutils[._-]v?(\d+(?:\.\d+)+).dsc/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff7dbcabe95b2f1fb816e7beb7899636809b0209b45d99b1d88661dcb929fb8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa867345e076321638da926c7c5c339d404a20861077095918c404ebef0e0cd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a501f8de9b1a2654efa102a049dd181cfab7fd3a91cdbb86d4ed33219cfcd6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0c2f9e9219767f62d6bf7743e4dccf930fe062c59a4ea13e40031ddd4c239e"
    sha256 cellar: :any_skip_relocation, ventura:       "26a45771021e5520b95eaff418ae8217ea26a052e90ae0c66b2a53af75653b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eedf40ac046afc99b2c62f565dbdc97e85e6ec68378ea12fdbb1edcf547b9900"
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
