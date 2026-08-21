class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://github.com/Softmotions/iowow"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6a5205f36f502e03528e545c98df4f6996276418670ed0ff175cd71566ffea88"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "64c7b7229c2eac8a23114ec5870756f06b3f46067bb8e1ca45c4c4eb44008b5e"
    sha256 cellar: :any, arm64_sequoia: "ed1890a1691b99cdd2b3ef3fe267d6755d1a5131628ab73bc275794412bcfb86"
    sha256 cellar: :any, arm64_sonoma:  "baf38d7a4da7b14d04aa82fee364e08d9b5247dadbf038dc51532fc0e1f7baad"
    sha256 cellar: :any, sonoma:        "4d9f2a9787929dffef6b73cf919ebfc956581dffc80e0f4800b0ef2202d10b33"
    sha256 cellar: :any, arm64_linux:   "89ecec5de8fcaf41c6827b3466193e65d3c404a1c9f35b8bd9441e6deeea3967"
    sha256 cellar: :any, x86_64_linux:  "63ef94d475a593f2ea26fa2ff35fd831c3e27a7321f28e96d008a307160cfc9b"
  end

  depends_on "pkgconf" => :build

  def install
    ENV["BUILD_TYPE"] = "Release"
    system "./build.sh", "--prefix=#{prefix}", "--libdir=lib", "--includedir=include",
                         "--pkgconfdir=lib/pkgconfig", "--jobs=#{ENV.make_jobs}",
                         "-DIOWOW_BUILD_SHARED_LIBS=1", "--install"

    # Upstream also installs a copy of the source tree.
    rm_r pkgshare
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <iowow/iwkv.h>
      #include <stdio.h>

      int main(void) {
        IWKV_OPTS opts = { .path = "test.db", .oflags = IWKV_TRUNC };
        IWKV iwkv;
        IWDB db;
        if (iwkv_open(&opts, &iwkv) || iwkv_db(iwkv, 1, 0, &db)) return 1;

        IWKV_val key = { .data = "foo", .size = 3 };
        IWKV_val val = { .data = "bar", .size = 3 };
        if (iwkv_put(db, &key, &val, 0)) return 1;

        val.data = 0;
        val.size = 0;
        if (iwkv_get(db, &key, &val)) return 1;
        printf("%.*s => %.*s\n", (int) key.size, (char *) key.data,
               (int) val.size, (char *) val.data);

        iwkv_val_dispose(&val);
        iwkv_close(&iwkv);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-liowow", "-o", "test"
    assert_equal "foo => bar\n", shell_output("./test")
  end
end
