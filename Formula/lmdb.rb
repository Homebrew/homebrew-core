class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.29/openldap-LMDB_0.9.29.tar.bz2"
  sha256 "182e69af99788b445585b8075bbca89ae8101069fbeee25b2756fb9590e833f8"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9f0fb7ee716181ea0197b4cd2731e1a7b68077168065cf40753fdeed7ad25b70"
    sha256 cellar: :any, big_sur:       "df699787f64959d4990f90e2e5cd873b01038387f5bcda6a9a2e6dbc73d0262f"
    sha256 cellar: :any, catalina:      "41941922c4e5f8367887ac21f632f132dd3b7eb19d749a61580364595cf1ccb4"
    sha256 cellar: :any, mojave:        "6d59993e9a2ff698c7c658a2a6fd90e5f6afebd43bc155a70b2691991e1eb67b"
  end

  def install
    cd "libraries/liblmdb" do
      ext = ""
      on_macos do
        ext = "SOEXT=.dylib"
      end
      system "make", ext
      system "make", "install", ext, "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
