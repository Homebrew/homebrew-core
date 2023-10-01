class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.31/openldap-LMDB_0.9.31.tar.bz2"
  sha256 "2132b8261d241876ce5fe10a243b2f7e0127eecaaff30039573eadc09e3acee6"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edb346889ca3da39bdc56f06cd357ea7d0f395bcf2cf8e09c6796738902eddc5"
    sha256 cellar: :any,                 arm64_ventura:  "d5fc0e7ddf34975d3d059acdafe24a0ff8b2ad06ab885daa56e0b39d35e62e39"
    sha256 cellar: :any,                 arm64_monterey: "df0af406ba05e10c20affbb89c96a1d57893315a24897206dafd4caa0f71cfd7"
    sha256 cellar: :any,                 arm64_big_sur:  "c8f083bb749cf113b75048abdc2e68455ff4e7b7ef0255441904b2cb335e83bf"
    sha256 cellar: :any,                 sonoma:         "f89d897aa24ef6df491ad1a91e341a644ab37711ed61e8f520b54b3b8c8bcda1"
    sha256 cellar: :any,                 ventura:        "c99efea54f5107b6326a79f39b8670c464ba13230b4dfbf969f34527835c80e8"
    sha256 cellar: :any,                 monterey:       "ec302b289dd892a4917ea5c971554bb38dd19d87852d3476fb47a248676e2008"
    sha256 cellar: :any,                 big_sur:        "1b237d14c62923901686ca9eb80eb2f50301dfcd640b93d27b9c5b7410f79fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f0368c65048ba0ff16bf90d71e95b0b165b0c3f5cc2f4a5497d58c01b96621"
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
