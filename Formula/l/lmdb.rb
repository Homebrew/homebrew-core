class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/symas-embedded-database-lmdb"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_0.9.33/openldap-LMDB_0.9.33.tar.bz2"
  sha256 "d19d52725800177b89d235161c0af8ae8b2932207e3c9eb87e95b61f1925206d"
  license "OLDAP-2.8"
  version_scheme 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e1c31973f9ca97144a4dfc934986203153bdc093cce84c09c6ed3ee71d7887fb"
    sha256 cellar: :any,                 arm64_sequoia:  "793c48c12fba8c6c49a9a390f1d142f9e21fbd67a300b89db0ad14e8c2b0b799"
    sha256 cellar: :any,                 arm64_sonoma:   "03945de1d7a1c49c341852a1efb8eaa431b4024a9920734b7e580c762be685cc"
    sha256 cellar: :any,                 arm64_ventura:  "013c00a97026bc02ebc64c1064ec4d91c8b0ca88e7de8905e7474ff04ad7bb17"
    sha256 cellar: :any,                 arm64_monterey: "6eb88efa4257b87f20ce077361aeef457f6939de01bb4131b33692e272fa3340"
    sha256 cellar: :any,                 sonoma:         "2b91b9e0509dfaaa6d8519023f398f294f512165e8df13e3bd61090bef0843a1"
    sha256 cellar: :any,                 ventura:        "f6669607cf9b8d2aa52c0c1bf3a98cd0246da69b249cd1d265b80275d3ab0846"
    sha256 cellar: :any,                 monterey:       "affb1315fdb4fa6bfa23af3340cbf58cdc1d66911c39e5beb0e26b68d9b34c83"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "38ec12a50b6addec5f94a800a82f29349b6674e5ba1d44c73e5ca159e771f1d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8505f02598426843842d04507a63658185cb0ec0abb2e4f561eda10719bf564"
  end

  depends_on "pkgconf" => :test

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
