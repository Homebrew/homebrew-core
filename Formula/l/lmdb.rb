class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/lmdb.php"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_1.0.2/openldap-LMDB_1.0.2.tar.bz2"
  sha256 "f35a2eb3a8e51650397604bbb49a1295221cd4739ff787d324f6c442c138a3ee"
  license "OLDAP-2.8"
  version_scheme 1
  compatibility_version 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "73ca53399b31f5e285b3ba59d5f7b63d163304c296397c4d6062e3173e9b7759"
    sha256 cellar: :any, arm64_tahoe:       "25de37350b3afc08c8ad81939a88b05ecc8810ac7f0908bd1c9c897ea351042a"
    sha256 cellar: :any, arm64_sequoia:     "bcb12afd2757b2790ba1297a8a482fc5ea8afe1205d5a4e4317e9ed2803f1639"
    sha256 cellar: :any, arm64_sonoma:      "53d4566b101a98faa59709aa1d44444b6d384c84048b4708567076f4160c09e1"
    sha256 cellar: :any, arm64_linux:       "cba5547a82780ede803fa0a0705dd4730b67954943ee00dbba8351596959c672"
    sha256 cellar: :any, x86_64_linux:      "e9b064deedfc049c057f13ff56a1d2939c172fef630df22145adbbc7a1250875"
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
