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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "b5f47a30b05abdf0209b87cd8cf4732c45aa87e22623f0543319b6409c14e236"
    sha256 cellar: :any,                 big_sur:       "c217caa7fc1ab0a1e734739a6a7aae31c9719198b47f487ea266ebcdd8b2c538"
    sha256 cellar: :any,                 catalina:      "b724f5fd1c3a779c43b36426dba75fea12bec8bab0324e5037b45032133dddac"
    sha256 cellar: :any,                 mojave:        "4385403822588575788671d0b2c22edc4543fd76b94ac3228c99fe516c7e4d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76758cef0c1fec8530043507ced0c543727e6240654f1751925fc9857ccb6e8b"
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
