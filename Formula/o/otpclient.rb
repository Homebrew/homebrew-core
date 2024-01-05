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
  depends_on "util-linux"
  depends_on "zbar"

  def install
    ENV["PKG_CONFIG_PATH"] = Formula["util-linux"].lib/"pkgconfig"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.base64").write <<~EOF
    STTaihPK7JECccemI8AQUhErkdossqBxq1S5KgrYlVr4YGhU/djZFCqoFsFrTcyxPYD+3OmOUZyQKiffLAK7bOm+z5YyzbYcDrfLMAKjli0oTyDVT2FzG2PS3mVKi4DOnyAo087h5s/pdTChUkeQsYuD82dvuPNbHaMnDrFzHjFRxPBYyR0bv9qVO9zK9NT3m1eHzOFQa+yRSVoC/fPgNLSrIOyrEzxLassAbw==
    EOF
    system "base64 -d -i test.base64 -o test.enc"
    (testpath/"list.exp").write <<~EOF
    #!/usr/bin/expect
    log_user 0
    spawn otpclient-cli list
    expect -exact "Type the absolute path to the database: "
    send -- "#{testpath/"test.enc"}\r"
    expect -exact "Type the DB decryption password: "
    send -- "iei54v\r"
    log_user 1
    expect eof
    EOF
    list_out = <<~EOF
    \r
    ================\r
    Account | Issuer\r
    ================\r
    wpb7fd | beep7x\r
    ----------------\r
    EOF
    system "chmod", "+x", testpath/"list.exp"
    assert_equal list_out, shell_output(testpath/"list.exp")
  end
end
