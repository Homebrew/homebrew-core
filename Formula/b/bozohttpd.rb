class Bozohttpd < Formula
  desc "Small and secure http version 1.1 server"
  homepage "http://www.eterna.com.au/bozohttpd/"
  url "http://www.eterna.com.au/bozohttpd/bozohttpd-20220517.tar.bz2"
  sha256 "9bfd0942a0876e5529b0d962ddbcf50473bcf84cf5e4447043e4a0f4ea65597a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8ac292a7d26ffaa74a4b1ceeeebcdf67374e4e1dcd01f717f887963374caabe6"
    sha256 cellar: :any,                 arm64_ventura:  "a347feb592ef7cb6891316a014a3623413904385760b8ced6d5bcf16b7fa4e75"
    sha256 cellar: :any,                 arm64_monterey: "e82cf2e3855babaf2031b04dd743a09aa58ad3bc7797b19c986305af17a1a78b"
    sha256 cellar: :any,                 sonoma:         "56191492a140d944c4e19f57d27dc6304721080efabbc60e0b8cf02474737a09"
    sha256 cellar: :any,                 ventura:        "10b6530e5e25d4ace501a31511230df6361136eb6d240bbd606b1522d0a8ad6d"
    sha256 cellar: :any,                 monterey:       "594536c4a63b2010b8f3d7939cbb64b160471b2b6c695c21106dc41309580f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd5ed984d13939f8c193b697794540e2b52294e246ed5da888f09f4f357b43f"
  end

  depends_on "pkg-config" => :build
  depends_on "lua"
  depends_on "openssl@3"

  def install
    # Both `cflags` are explained at http://www.eterna.com.au/bozohttpd/bozohttpd.8.html
    cflags = [
      # Disable NetBSD blocklistd supprt, which is enabled by default (see section "BLOCKLIST SUPPORT")
      "-DNO_BLOCKLIST_SUPPORT",
      # Enable basic authentication, which is disabled by default (see section "HTTP BASIC AUTHORIZATION")
      "-DDO_HTPASSWD",
    ]
    cflags << Utils.safe_popen_read("pkg-config", "--libs", "--cflags", "lua").chomp
    cflags << Utils.safe_popen_read("pkg-config", "--libs", "--cflags", "libcrypto").chomp

    ENV.append "CFLAGS", cflags.join(" ")
    system "make", "-f", "Makefile.boot", "CC=#{ENV.cc}"
    bin.install "bozohttpd"
  end

  test do
    port = free_port

    expected_output = "Hello from bozotic httpd!"
    (testpath/"index.html").write expected_output

    fork do
      exec bin/"bozohttpd", "-b", "-f", "-I", port.to_s, testpath
    end
    sleep 3

    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
  end
end
