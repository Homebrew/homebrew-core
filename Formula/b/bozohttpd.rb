class Bozohttpd < Formula
  desc "Small and secure http version 1.1 server"
  homepage "https://pkgsrc.se/www/bozohttpd"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/LOCAL_PORTS/bozohttpd-20240126.tar.bz2"
  sha256 "576267bc5681c52b650294c3f2a85b8c8d8c239e75e71aaba7973771f852b56d"
  license "BSD-2-Clause"

  livecheck do
    url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/"
    regex(/href=.*?bozohttpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f071d5d2e28bc3a4ccef5b81d780fbd3995a5cca9d508356ffa860ede9737bf6"
    sha256 cellar: :any,                 arm64_sequoia: "f91adb497f96847759c3427e7b14b81889547273bc078266abdcc0087e6f1c8f"
    sha256 cellar: :any,                 arm64_sonoma:  "ad727b862019134b028cc9d5ee6893755dc001ab87ebc3625eca39779be2d65a"
    sha256 cellar: :any,                 arm64_ventura: "5269de6704ed5507508a2bfba45dfb714d0a077bb86682cc013762a3e05dbaba"
    sha256 cellar: :any,                 sonoma:        "58b534558d746a783487067bcb393d6908c9961f1e8e82e2c8ff0e2790e5c7aa"
    sha256 cellar: :any,                 ventura:       "282ae1e2332c2dc426187b193fc943141bfd838b00818aa867da2eac281144c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ddfe6c1eedfc12b72ce6175e8bb8621d3c5b2cd946d5f35de76cf555c1dcd5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f662a5761fcd610221da12ac4476496fe39bb5254c0192a05e6170b495c988"
  end

  depends_on "pkgconf" => :build
  depends_on "lua"
  depends_on "openssl@3"

  def install
    # Both `cflags` are explained at http://www.eterna.com.au/bozohttpd/bozohttpd.8.html
    cflags = [
      # Disable NetBSD blocklistd support, which is enabled by default (see section "BLOCKLIST SUPPORT")
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

    spawn bin/"bozohttpd", "-b", "-f", "-I", port.to_s, testpath
    sleep 3

    assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
  end
end
