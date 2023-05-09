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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3cf7eaae03029dc419ee5172b80ea09c8f334ad0ae842e28624795ca2b0542c5"
    sha256 cellar: :any,                 arm64_monterey: "87acfdfcd7e9644da38feae8e8b7434c22c7ccbfbcb3fb01864c1f3eff459cb0"
    sha256 cellar: :any,                 arm64_big_sur:  "4ad4a63e3b410490adf55ce927745ceab1c3fe4ce63aaf77dba30453f6b6dc8c"
    sha256 cellar: :any,                 ventura:        "a848af0b02d21dd8d86fc4f65ae45e240d3f867c4bd26741254499dd4469f374"
    sha256 cellar: :any,                 monterey:       "0faef96a914e892880affd464c01557ebacb89e0b9dd4d7bf1b4a246899f315d"
    sha256 cellar: :any,                 big_sur:        "e79218ff65d869ed134dd605a606ac291b41ca67e249729b53042086000f76eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e883cdef787fad7081cfbcda65af6824ef838210b4d6db73355920dd0e6ad8"
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
