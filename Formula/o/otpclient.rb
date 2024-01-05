class Otpclient < Formula
  desc "C/GTK3 OTP client that supports both TOTP and HOTP"
  homepage "https://github.com/paolostivanin/OTPClient/wiki"
  url "https://github.com/paolostivanin/OTPClient/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "f926155ef104e4965561e668a2e5128cdb7ed19af49ba7e693b580883fdae048"
  license "GPL-3.0-only"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "jansson"
  depends_on "libcotp"
  depends_on "libgcrypt"
  depends_on "libpng"
  depends_on "libsecret"
  depends_on "protobuf-c"
  depends_on "qrencode"
  depends_on "zbar"

  def install
    inreplace "CMakeLists.txt",
      "pkg_check_modules(UUID REQUIRED uuid>=2.34.0)",
      "pkg_check_modules(UUID REQUIRED uuid>=1.0)"
    mkdir "build" do
      system "cmake", "-S", "..", "-B", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "true"
  end
end
