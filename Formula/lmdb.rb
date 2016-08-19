class Lmdb < Formula
  desc "Lightning memory-mapped database: key-value data store"
  homepage "https://symas.com/mdb-and-sqlite/"
  url "https://github.com/LMDB/lmdb/archive/LMDB_0.9.18.tar.gz"
  sha256 "dd35b471d6eea84f48f2feece13d121abf59ef255308b8624a36223ffbdf9989"
  head "https://github.com/LMDB/lmdb.git", :branch => "mdb.master"

  bottle do
    cellar :any
    revision 1
    sha256 "1ff98cfc65fcea5c494d9bd097500b7977d57a8760da8475c7f053c85f8cb8da" => :el_capitan
    sha256 "49b620b1ddb51161db870b239de4cf699a7d2b97de1e13901e5fdc8d3358394e" => :yosemite
    sha256 "fec09772155dae25a6aec9422e07927e60ad5ef0f3d95b1aca12ba464ed347f6" => :mavericks
    sha256 "3ad74588a349fb8e4bacb63017c52928001d2adf1a41adde0282ba2bb35f3165" => :mountain_lion
  end

  def install
    cd "libraries/liblmdb" do
      # Reported 19 Aug 2016: http://www.openldap.org/its/index.cgi?findid=8481
      inreplace "Makefile", ".so", ".dylib"

      system "make"
      system "make", "test"
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdb_dump -V")
  end
end
