class Libpostal < Formula
  desc "Library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "02883c2f62658a09f9e49819f7983c7b19a574f9422424ecd5e4ff43cf7830a8"
  license "MIT"
  head "https://github.com/openvenues/libpostal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "0a6f889d4b41b5cbfd4a64dbdfb2c7e61a58eafcffe57335ff88edf9419f2838"
    sha256 arm64_sequoia: "fbf12aa77b62468c76d5ac57d38f81c0e5cd379a9af827723cded2e09f45db40"
    sha256 arm64_sonoma:  "9c6f9de07f3285847e3b7831c0f2bf8fc163ef95654574d8b47736392158b709"
    sha256 sonoma:        "80fa9ed5f262fb37122bff7c246a211ed48a2de3de9e2a64b543e34cbd20dca4"
    sha256 arm64_linux:   "f462facf77dfb1a6231b76f42201ee1ca5e26de5bfcc8a19b6d57d52218a463e"
    sha256 x86_64_linux:  "1f054e6c0e4f0a12845e343c5e406a0683faf9ba71dd3880e30bcb23ad5199c1"
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
