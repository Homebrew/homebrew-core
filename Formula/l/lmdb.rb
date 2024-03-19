class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.32/openldap-LMDB_0.9.32.tar.bz2"
  sha256 "039be48414f71299d04fb01da3e1a6461075bb77eaeeeda36ee5285de804ebf6"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5774284afa9dad2cf29b5033b2e5791d79d3a3dc786b429ca7816fcf716a4aec"
    sha256 cellar: :any,                 arm64_ventura:  "d6e4a706772c6ab9aa4b2084a3b796adfadc3f06c6c7b95be42a982a65f2b9ba"
    sha256 cellar: :any,                 arm64_monterey: "d4d6738802f6ca97162f2fcc016849ed666eb87f8e9e598dd998aceba465e19a"
    sha256 cellar: :any,                 sonoma:         "389a8cec32cbc4a94ca91d7c09ba2a59ac7540f634466b22d0893b504c33c586"
    sha256 cellar: :any,                 ventura:        "09d25d1ac6eec2d62bb923c0805702ce5facc37678488e471967f9fff34b3548"
    sha256 cellar: :any,                 monterey:       "d2ac9c00f1d57a865bc07cd30049571b336a16952c7324dad85c57b4ef0ccd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f4557c0876dc96ba0559a0ef557b06cededb989f9d7cc7636320cce0577b77"
  end

  depends_on "pkg-config" => :test

  def install
    cd "libraries/liblmdb" do
      args = []
      args << "SOEXT=.dylib" if OS.mac?
      system "make", *args
      system "make", "install", *args, "prefix=#{prefix}"
    end

    (lib/"pkgconfig/lmdb.pc").write pc_file
    (lib/"pkgconfig").install_symlink "lmdb.pc" => "liblmdb.pc"
  end

  def pc_file
    <<~EOS
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
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")

    # Make sure our `lmdb.pc` can be read by `pkg-config`.
    system "pkg-config", "lmdb"
  end
end
