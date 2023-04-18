class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.30/openldap-LMDB_0.9.30.tar.bz2"
  sha256 "eb16ed6fd535b85857c331b93e7f9fd790bc9fcea3fa26162befdc1ba2775668"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f1ea55a9f4f7a3565d6c61bf21eeac9c13a575689bfd9e98dd42f04d042ae62d"
    sha256 cellar: :any,                 arm64_monterey: "912f1cf80f6cf814f346e5856a67665c7017d64697aa12c10e6777e25e041f01"
    sha256 cellar: :any,                 arm64_big_sur:  "ef12324f72c48750b37bd7a46d150c386d4d672fd19cc2771b8a60a8795fde32"
    sha256 cellar: :any,                 ventura:        "b054857dc8192666dd874b658ef29da7d20b6478404198122baa73837298b43a"
    sha256 cellar: :any,                 monterey:       "fab2dedfe00c4310e0969d5e8ba6bb23a3833c7b0d51de06e4e23b171b9db3ec"
    sha256 cellar: :any,                 big_sur:        "11661f90b4de7844fb35144b40430f6678f34b4f4dc44184680d1b3a2d5aab97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e38babc366e6564e3c0971db2df8a09d9d71225c5f90c924a43c2f6b8c0bc87"
  end

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
