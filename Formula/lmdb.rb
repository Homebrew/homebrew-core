class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/lmdb/"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.27/openldap-LMDB_0.9.27.tar.bz2"
  sha256 "2746e429364bfa6f048f2980b8aab6ef461937e33e5c955d7b6242719b2527c4"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :head
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "6244986c2cd93bd2770fc0cfac79f80e9d98ea197d84acce00322335fe9e2e18" => :big_sur
    sha256 "706f2a266c430ad3cffcbf5bc9e87a6d1e63a9eb7f2d74b3b95c28e8910cd71d" => :arm64_big_sur
    sha256 "1495b5b154e77771ff450d1687c2afeec377db57498900b2bb692d23b4bd25b8" => :catalina
    sha256 "496f41bc0f050e5657a4ecc1409fccf8f2247521c3d3ebe16bdeb2007e0dbc71" => :mojave
    sha256 "36d2564ec79b8547154e706980fbc25d38575d424299216ec10adae598e6b1c9" => :high_sierra
  end

  def install
    cd "libraries/liblmdb" do
      system "make", "SOEXT=.dylib"
      system "make", "install", "SOEXT=.dylib", "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
