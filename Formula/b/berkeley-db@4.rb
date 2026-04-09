class BerkeleyDbAT4 < Formula
  desc "High performance key/value database"
  homepage "https://www.oracle.com/database/technologies/related/berkeleydb.html"
  url "https://download.oracle.com/berkeley-db/db-4.8.30.tar.gz"
  sha256 "e0491a07cdb21fb9aa82773bbbedaeb7639cbd0e7f96147ab46141e0045db72a"
  license "Sleepycat"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "de4afa55a39dde81bdc017b071d7ce98271d88bc440aecc89c21d426e27486e6"
    sha256 cellar: :any,                 arm64_sonoma:   "6a70bef2a6c9d8fcc8530348fdd1040aef31136d27ec7fcd3c2dfb009ae909f6"
    sha256 cellar: :any,                 arm64_ventura:  "dad3afeb395f771ec875428b208e25bb72a052f6b855832817491952ab9f5f02"
    sha256 cellar: :any,                 arm64_monterey: "ec19587b4fb0d7ee44a351aed1ed2912e327acdd4de816baee6ec9f3a9dfc7ff"
    sha256 cellar: :any,                 arm64_big_sur:  "4cc3d7123506a695892eb450c704ae6a2f26fd865dcab7bb9290431c5ed4add5"
    sha256 cellar: :any,                 sonoma:         "af1faa2764731448aaa9ff5a24b570905a280a7b11354cbb997c2e2da2a24aa9"
    sha256 cellar: :any,                 ventura:        "19169bd9bb20a1625afc20a9da826825ddc2fc707a894eee0c8428102b2c4bee"
    sha256 cellar: :any,                 monterey:       "7b227d2e4f39efef969bc407bc04c5bbf7f2cfcce6e0e731680342777dd7f2be"
    sha256 cellar: :any,                 big_sur:        "8a95577ecc798d7dd61b100d282c3b667eb278b3d719a41331db2cc57e0843c1"
    sha256 cellar: :any,                 catalina:       "3ef8ec895927523c7a7c2c8c18af534ed00abd9b0d35664a3464595906adcee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "055768ef5debedea1692119a19af00031e6ab66431ae47d635d0f2d4c46d40e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41de3e62651a2b5b8a3ae23b18b1331478c38fac38c1446627cd0d82c1e657d8"
  end

  keg_only :versioned_formula

  # This formula is less likely to get security patches than `berkeley-db@5`,
  # which is the version shipped & patched by major Linux distros.
  deprecate! date: "2024-08-17", because: :unmaintained
  disable! date: "2025-08-24", because: :unmaintained

  # Fix build with recent clang
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/berkeley-db@4/clang.diff"
    sha256 "86111b0965762f2c2611b302e4a95ac8df46ad24925bbb95a1961542a1542e40"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    directory "dist"
  end

  def install
    # BerkeleyDB dislikes parallel builds
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-cxx
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    # BerkeleyDB requires you to build everything from the build_unix subdirectory
    cd "build_unix" do
      system "../dist/configure", *args
      system "make", "install"

      # use the standard docs location
      doc.parent.mkpath
      mv prefix/"docs", doc
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <assert.h>
      #include <string.h>
      #include <db_cxx.h>
      int main() {
        Db db(NULL, 0);
        assert(db.open(NULL, "test.db", NULL, DB_BTREE, DB_CREATE, 0) == 0);

        const char *project = "Homebrew";
        const char *stored_description = "The missing package manager for macOS";
        Dbt key(const_cast<char *>(project), strlen(project) + 1);
        Dbt stored_data(const_cast<char *>(stored_description), strlen(stored_description) + 1);
        assert(db.put(NULL, &key, &stored_data, DB_NOOVERWRITE) == 0);

        Dbt returned_data;
        assert(db.get(NULL, &key, &returned_data, 0) == 0);
        assert(strcmp(stored_description, (const char *)(returned_data.get_data())) == 0);

        assert(db.close(0) == 0);
      }
    CPP
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldb_cxx
    ]
    flags << "-Wl,-rpath,#{lib}" if OS.linux?
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
    assert_path_exists testpath/"test.db"
  end
end
