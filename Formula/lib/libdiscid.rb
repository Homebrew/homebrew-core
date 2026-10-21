class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.7.0.tar.gz"
  sha256 "c230ed462c5ed7d7403ceb6984c57c8d05de42386d796bcd893636c0b0ba222f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "11a4831074586d185aae50c238f9fe4fb0edfb9176b6f2d474799e7d4263cbcc"
    sha256 cellar: :any, arm64_tahoe:       "fc45e6f5f937c3769bc2ecefda8c87876c13c480256c2d4418a5efe82524dce6"
    sha256 cellar: :any, arm64_sequoia:     "aaf2881b3b65a00777e497249afcf0f95b7fe51c8375c60aec3446148896c8f7"
    sha256 cellar: :any, arm64_sonoma:      "b655f25d9cf870e3bd44cb9587a534ecc8e9475a87decccb3b77595fc067aa3c"
    sha256 cellar: :any, sonoma:            "c96b31f639b8f552783c91d069f0d75e98f49c4aa00bd2aa2266821936b467d3"
    sha256 cellar: :any, arm64_linux:       "32c4923845f7ee7a78b23b16ade61efd47a2ff63a4c96f4ecdababbd07064116"
    sha256 cellar: :any, x86_64_linux:      "fef1a5a18839392e32cff0187636167296c283189748a6f170744bc4a236448d"
  end

  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <discid/discid.h>

      int main(void) {
        int offsets[] = {
          303602,
          150, 9700, 25887, 39297, 53795, 63735, 77517, 94877, 107270,
          123552, 135522, 148422, 161197, 174790, 192022, 205545,
          218010, 228700, 239590, 255470, 266932, 288750,
        };
        DiscId *d = discid_new();
        if (!discid_put(d, 1, 22, offsets)) return 1;
        printf("%s\\n", discid_get_id(d));
        discid_free(d);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs libdiscid").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    assert_equal "xUp1F2NkfP8s8jaeFn_Av3jNEI4-", shell_output("./test").strip
  end
end
