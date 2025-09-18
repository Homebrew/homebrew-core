class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.8.0/dar-2.8.0.tar.gz"
  sha256 "061fcad82e694797179c51dba013bd49544db04b852693b973f4ec37cf3ad78a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "91d75a1dc3d971d89dfc2c55d0a82bf6848dd9cbd2aa2ec70d8db9be7057d70b"
    sha256 arm64_sequoia: "e48f75e42258459cb4538ff52cf5283a9cdac5095c51f15aae32c1b40a341474"
    sha256 arm64_sonoma:  "c1f87a2f60cff04bd94da1086e72be3c849dbdf0ea4a62a47a88e40ccec634ef"
    sha256 arm64_ventura: "ab164640255def4faff3ff6a2c97aa5b103253c45c0c47638ecfc5843bdcd143"
    sha256 sonoma:        "5250da53437553e23e918309ecb2d286f329f7694afe022b3a08e722ee5b4159"
    sha256 ventura:       "0582a3b781c4828c181a43fa7a4e396102a44199a5e247ea1ab22ce06131cc0d"
    sha256 arm64_linux:   "d8ae4c87c780b22d8e37dbc7ae321f71f0568dfa553a14051b6ba9607603fbd8"
    sha256 x86_64_linux:  "d2e7b4f89b7f6ad522571c94030cb0f47c3857410a4eb1c5cb755d77852a1234"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
