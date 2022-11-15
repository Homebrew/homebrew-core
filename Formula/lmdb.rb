class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "d6793d7269a7aa6ca79c684f0c2813963eead9a2139aabc4d7dff676a04d40fa"
    sha256 cellar: :any,                 arm64_monterey: "5a02c8325714c21cf296f22807ab3eeca897e88f7163f9202b29cfbc97b1cce1"
    sha256 cellar: :any,                 arm64_big_sur:  "c41fb2e2798d68609b974ab0897a2aee8a09628f34e93b4d2dca9b39c96a8fd0"
    sha256 cellar: :any,                 ventura:        "8529779660590fb75751ce4b934be80c254eea795dd3dc8c5724cbbbfcad619f"
    sha256 cellar: :any,                 monterey:       "7425bcf375008775546c80f8e783fc01cea763d597e049abf5e0b64dfcbaf8ee"
    sha256 cellar: :any,                 big_sur:        "4b09b12695d58a6f3e311df5d0b80719ca409a4e47424a77425b008582ec5ddf"
    sha256 cellar: :any,                 catalina:       "2b0ba99f6858d120ff7ab84fe0af0268523d3643246d56e0156161f32c3beff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5cb6f9534ff4823b76d71214fed3f29bef56b73fd6feb691d047abf92795c95"
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
