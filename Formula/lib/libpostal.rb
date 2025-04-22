class Libpostal < Formula
  desc "Library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/refs/tags/v1.1.tar.gz"
  sha256 "8cc473a05126895f183f2578ca234428d8b58ab6fadf550deaacd3bd0ae46032"
  license "MIT"
  head "https://github.com/openvenues/libpostal.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "977117dd4cbadd9c7a54b1a98cbf8a4cf5d76435d3fb2a4bd7219777b7ddac8c"
    sha256 arm64_sonoma:  "814ede166ebe7352cc9850527f29e9395eea6a2248a16ad450d0606216923e25"
    sha256 arm64_ventura: "e6412f74a7d126a91f3c29337f73e3284329c95b1fba7924a653f3115918802c"
    sha256 sonoma:        "077f8b1500c01ca5f5c6586b6570d33c0af2285b4d6e2811af431918b4b382c0"
    sha256 ventura:       "4e553905102caddeb88a154bd251748381ca94ee63ce1b2f56cf80e65aabe327"
    sha256 arm64_linux:   "aed0795c4d0a2894d8297bca8dd6b758aa4aecac1af139cb5491c9e9b75a98ea"
    sha256 x86_64_linux:  "6f935c41597746bddc0c0e0fcc132f7e9ed9de317f8a49702f25cc01ce4fe844"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  # These resources reference the `v1.0.0` tag from the `libpostal` repository,
  # even though that is not the most recent stable version of the code.
  # `libpostal` requires these data files in order to work, and it appears that
  # the data files are versioned independently from the code itself.
  resource "libpostal_data" do
    url "https://github.com/openvenues/libpostal/releases/download/v1.0.0/libpostal_data.tar.gz"
    sha256 "d2ec50587bf3a7e46e18e5dcde32419134266f90774e3956f2c2f90d818ff9a1"
  end
  resource "parser" do
    url "https://github.com/openvenues/libpostal/releases/download/v1.0.0/parser.tar.gz"
    sha256 "7194e9b0095f71aecb861269f675e50703e73e352a0b9d41c60f8d8ef5a03624"
  end
  resource "language_classifier" do
    url "https://github.com/openvenues/libpostal/releases/download/v1.0.0/language_classifier.tar.gz"
    sha256 "16a6ecb6d37e7e25d8fe514255666852ab9dbd4d9cc762f64cf1e15b4369a277"
  end

  def install
    pkgshare.install resource("libpostal_data")
    (pkgshare/"language_classifier").install resource("language_classifier")
    (pkgshare/"address_parser").install resource("parser")
    (pkgshare/"data_version").write "v1"

    system "./bootstrap.sh"

    args = [
      "--datadir=#{share}",
      "--disable-data-download",
    ]
    args << "--disable-sse2" if Hardware::CPU.arm?
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # remove script for downloading data -- it's unnecessary
    rm bin/"libpostal_data"
  end

  test do
    # This test file is copied from the project README:
    # https://github.com/openvenues/libpostal?tab=readme-ov-file#usage-parser
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <libpostal/libpostal.h>

      int main(int argc, char **argv) {
        // Setup (only called once at the beginning of your program)
        if (!libpostal_setup() || !libpostal_setup_parser()) {
          exit(EXIT_FAILURE);
        }

        libpostal_address_parser_options_t options = libpostal_get_address_parser_default_options();
        libpostal_address_parser_response_t *parsed = libpostal_parse_address("781 Franklin Ave Crown Heights Brooklyn NYC NY 11216 USA", options);

        for (size_t i = 0; i < parsed->num_components; i++) {
          printf("%s: %s\\n", parsed->labels[i], parsed->components[i]);
        }

        // Free parse result
        libpostal_address_parser_response_destroy(parsed);

        // Teardown (only called once at the end of your program)
        libpostal_teardown();
        libpostal_teardown_parser();
      }
    C

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libpostal").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"

    expected = <<~EOS
      house_number: 781
      road: franklin ave
      suburb: crown heights
      city_district: brooklyn
      city: nyc
      state: ny
      postcode: 11216
      country: usa
    EOS
    assert_equal expected, shell_output("./test")
  end
end
