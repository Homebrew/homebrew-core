class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/lmdb.php"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_1.0.1/openldap-LMDB_1.0.1.tar.bz2"
  sha256 "1ae17f11ebdeb0d69e53416bb6e0a7479a7d3d5b5ca443a474bff5b5f886a348"
  license "OLDAP-2.8"
  version_scheme 1
  compatibility_version 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e63ac4f1ee1a664b39877162ea66cba4761fccb868fad984bec7c3282218414"
    sha256 cellar: :any, arm64_sequoia: "2e0d8aadbabf97148fe9c572a87add07e02d52c61669c848205b54feb2e6bc80"
    sha256 cellar: :any, arm64_sonoma:  "9f5d865c6622999ad3b99dad56197ea5b4c01fb6bd80231ecd784b01355d7900"
    sha256 cellar: :any, sonoma:        "472ac24635bef354ee174db475f0cfd6c7aed98f6aaad1692e78de4e0e2fa026"
    sha256 cellar: :any, arm64_linux:   "8232f467c13a8c6ee225081d8f44c842f1ba2aab4dbf9ace3733d6509a44d04d"
    sha256 cellar: :any, x86_64_linux:  "f0b73e63e3954123ffea927bd082d1c30f5caf44e289eb870f931ae4aca84ad0"
  end

  depends_on "pkgconf" => :test

  def install
    cd "libraries/liblmdb" do
      args = []
      if OS.mac?
        args << "SOEXT=.dylib"
        # Apple's ld has no -soname; upstream suggests this alternative in the Makefile
        args << "VERSION_OPT=-Wl,-compatibility_version,$(LIBVER) -Wl,-current_version,$(VEREXT)"
      end
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end

    (lib/"pkgconfig/lmdb.pc").write pc_file
    (lib/"pkgconfig").install_symlink "lmdb.pc" => "liblmdb.pc"
  end

  def pc_file
    <<~PC
      prefix=#{opt_prefix}
      exec_prefix=${prefix}
      libdir=${prefix}/lib
      includedir=${prefix}/include

      Name: lmdb
      Description: #{desc}
      URL: #{homepage}
      Version: #{version}
      Libs: -L${libdir} -llmdb
      Cflags: -I${includedir}
    PC
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")

    # Make sure our `lmdb.pc` can be read by `pkg-config`.
    system "pkg-config", "lmdb"
  end
end
