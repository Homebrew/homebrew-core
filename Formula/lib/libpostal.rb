class Libpostal < Formula
  desc "Library for parsing/normalizing street addresses around the world"
  homepage "https://github.com/openvenues/libpostal"
  url "https://github.com/openvenues/libpostal/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "41ad2cd20261e6498f1843c8d21cd737470d17e975deb6ea2a5d1517880729d3"
  license "MIT"
  head "https://github.com/openvenues/libpostal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "cf3a9637bea332e8d28cde170dc85c7c5dbb4b5731886edd9f30bed504742e5b"
    sha256 arm64_sequoia: "954b38f9b41bb3fe6702b91e2589baa8023b459162dc3bfa3a3dd6218bf33312"
    sha256 arm64_sonoma:  "19638446df502bd5a2fa13bf21d89eca018e70965595940a03f89ca14b213609"
    sha256 sonoma:        "3f4ee3c0636f7fc19ddc1fc60a2273912f64a539dc314df0488d2eab8f856308"
    sha256 arm64_linux:   "32461394f17714bbf96a4a090b4e89240a2dd2a97637006ed0997d114d0831be"
    sha256 x86_64_linux:  "79bf7b3b79c1e80a9d61a7ad19599b9d18440390bec4babbf85a17ad5219db34"
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

    livecheck do
      url "https://raw.githubusercontent.com/openvenues/libpostal/refs/tags/v#{LATEST_VERSION}/versions/base_data"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "parser" do
    url "https://github.com/openvenues/libpostal/releases/download/v1.0.0/parser.tar.gz"
    sha256 "7194e9b0095f71aecb861269f675e50703e73e352a0b9d41c60f8d8ef5a03624"

    livecheck do
      url "https://raw.githubusercontent.com/openvenues/libpostal/refs/tags/v#{LATEST_VERSION}/versions/parser"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "language_classifier" do
    url "https://github.com/openvenues/libpostal/releases/download/v1.0.0/language_classifier.tar.gz"
    sha256 "16a6ecb6d37e7e25d8fe514255666852ab9dbd4d9cc762f64cf1e15b4369a277"

    livecheck do
      url "https://raw.githubusercontent.com/openvenues/libpostal/refs/tags/v#{LATEST_VERSION}/versions/language_classifier"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
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
