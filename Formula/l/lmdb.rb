class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://www.symas.com/lmdb.php"
  url "https://git.openldap.org/openldap/openldap/-/archive/LMDB_1.0.3/openldap-LMDB_1.0.3.tar.bz2"
  sha256 "015f482ba647e926fbddc9cea49ed59281229c12896cd18675484c36712b98bd"
  license "OLDAP-2.8"
  version_scheme 1
  compatibility_version 1
  head "https://git.openldap.org/openldap/openldap.git", branch: "mdb.master"

  livecheck do
    url :stable
    regex(/^LMDB[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5ffd1112c811d8aa88ddd40bcea8b52c52d0c3f55213e1fb7851955ddb18e198"
    sha256 cellar: :any, arm64_tahoe:       "4c99379ddea7824a8242cb27f48eb88d5a153ed542e08f801f72350a21e4258b"
    sha256 cellar: :any, arm64_sequoia:     "a8731d3aaab26dfe955286301f2aef058e210f91b4fbe6da82dbdcc8e389cf92"
    sha256 cellar: :any, arm64_linux:       "c816dde43ebbb4e52758ba0c7a97ac627c5ca06f2330499e2a57621cbd509b16"
    sha256 cellar: :any, x86_64_linux:      "7159ef8774e484ab2b96b89d247f227549e8f07df2dc87d38752dc476c164dbc"
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
