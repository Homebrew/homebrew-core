class Iowow < Formula
  desc "C utility library and persistent key/value storage engine"
  homepage "https://github.com/Softmotions/iowow"
  url "https://github.com/Softmotions/iowow/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "fc6104e50355de8369cb6f3007d9a61c9380d35c4159d345eca80ceee780e526"
  license "MIT"
  head "https://github.com/Softmotions/iowow.git", branch: "master"

  # TODO: remove if undeprecated
  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4dac6d27bde72bded22b86df1abc9a6e8b15cf9aec1b06600264d8865e999f3d"
    sha256 cellar: :any, arm64_sequoia: "a8bdcd631fcc6a10ac91ca6b7bc102a067b83e4c08a0b972dce7107dcb7e54ee"
    sha256 cellar: :any, arm64_sonoma:  "29b88ad755da56b931a27a0feb45225ff32483a102fff3c58ef26662054d4075"
    sha256 cellar: :any, arm64_linux:   "c1cf5c964e9c976f4fd37bb9e6fa3c880e6f70fc2b9d1b9169250eeae7a94965"
    sha256 cellar: :any, x86_64_linux:  "1e84629f06d514f9af58691b2b5ecfd2f4eb391fdf2920bc5a8baa5b6952e863"
  end

  # TODO: Can be considered for undeprecation on new release
  deprecate! date: "2026-09-18", because: :checksum_mismatch
  disable! date: "2027-09-18", because: :checksum_mismatch

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
