class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.6.1.tar.bz2"
  sha256 "961e0fa8b306443d41b1ebbd2c6e4e9d8fb4db850450f80785c4d4590f12d8ca"
  license "GPL-2.0-or-later"

  # Using HTTP rather than HTTPS to avoid SSL connection timeout
  livecheck do
    url "http://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "ed39d1e1ac1dc0f266916ece81e33dc22b266e07d7c98409006d22c2f3cd0a00"
    sha256 cellar: :any, arm64_golden_gate: "22aceba70b09b0e590d38c37c54f5da80507300be4a83e6ca103a65dd5905b25"
    sha256 cellar: :any, arm64_tahoe:       "709c6f82737e01325335fe8b829b363041dcdcaefd339f70938d6db33cebcc36"
    sha256 cellar: :any, arm64_sequoia:     "2c8e798f84258ce101d047efd34db83e9aa338b86bbdf6e86caee48ea295e4fe"
    sha256 cellar: :any, arm64_linux:       "a873eef5a88f386782c649476c20ed0fa2b1a42c044d77add8c712f50ec404ed"
    sha256 cellar: :any, x86_64_linux:      "717e49655ec1d9eb1398307ad5a5c66d12a901a26cb02b2f7a057531ec0fdaee"
  end

  depends_on "pkgconf" => :build
  depends_on "libsndfile"

  on_linux do
    depends_on "e2fsprogs"
    depends_on "util-linux"
  end

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libgig/gig.h>
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << gig::libraryName() << endl;
        return 0;
      }
    CPP
    args = %W[
      -L#{lib}/libgig
      -lgig
    ]
    args << "-Wl,-rpath,#{lib}/libgig" unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", *args, "-o", "test"
    assert_match "libgig", shell_output("./test")
  end
end
