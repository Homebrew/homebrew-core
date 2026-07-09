class Ip2location < Formula
  desc "C library and CLI to geolocate IP addresses"
  homepage "https://github.com/ip2location/IP2Location-C-Library"
  url "https://github.com/ip2location/IP2Location-C-Library/archive/refs/tags/8.7.0.tar.gz"
  sha256 "0c196016c281f685cb428011d4703360bca8a805f4efa777eb1bd29c8295d196"
  license "MIT"
  head "https://github.com/ip2location/IP2Location-C-Library.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "645d9e5100cc2503df2d30a60497a9ef9e9678ead559a8db93241d908ec903ab"
    sha256 cellar: :any, arm64_sequoia: "081f753903b049dd40c63d0696d9e76e05b9f507d53d1e8deb0a29b17813b7bb"
    sha256 cellar: :any, arm64_sonoma:  "ab7e1b231f2e33494b70475927dc8215c6d489241417db1e40ef8f976ba62aec"
    sha256 cellar: :any, sonoma:        "614f3d7c6e4362d683a2ab3d55ad06394ae5a158a4be8680c5204bc0ed06ee5e"
    sha256 cellar: :any, arm64_linux:   "811afd87cffff71e56ff314adec68dec44bd079e192ea36eebf8c9eb62610f0c"
    sha256 cellar: :any, x86_64_linux:  "3259d8bdf5369bacb44a615063c1398f6b1bf37db97a332cd7d5adafc32ffbe8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "perl" => :build

  def install
    # TODO: remove in the next release
    inreplace "Makefile.am", "ip2location_LDADD=-lrt", "ip2location_LDADD=" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Generate a sample IPv4 country database from the bundled CSV so the
    # library and CLI can be exercised against real data in the test block
    cd "data" do
      system "perl", "ip-country.pl"
      pkgshare.install "IP-COUNTRY.BIN"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <IP2Location.h>
      #include <stdio.h>

      int main(void)
      {
        printf("%s", IP2Location_api_version_string());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lIP2Location", "-o", "test"
    assert_equal version.to_s, shell_output("./test")

    assert_match "AU", shell_output("#{bin}/ip2location --data-file #{pkgshare}/IP-COUNTRY.BIN " \
                                    "--ip 1.1.1.1 --field country_code --no-heading")
  end
end
