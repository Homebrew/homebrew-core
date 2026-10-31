class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://github.com/lavv17/lftp/releases/download/v4.9.3/lftp-4.9.3.tar.gz"
  sha256 "68116cc184ab660a78a4cef323491e89909e5643b59c7b5f0a14f7c2b20e0a29"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "f953d155eba4323d2b51143403e282f99a09441c83bf6d65e829fddbf7105793"
    sha256 arm64_tahoe:       "b0e8fcf3cda8e78a46c407fd402e46eff31059387471799b747523ebcbdd5ecf"
    sha256 arm64_sequoia:     "ccbcd928c1f4ce526e2452d6c347d63a24b45015018756e1de5d4559fdf7a66c"
    sha256 arm64_linux:       "59792faee593d079b0771f0af58f15856a288a44884041f548c6cc101a749203"
    sha256 x86_64_linux:      "b9a2a281115d97c6cb81d8bcd9348059dc09becb0d7ee2cf69b8456f8e2391d9"
  end

  depends_on "libidn2"
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/lavv17/lftp/commit/e5d53bcb31b1f3792c6ab321e20d566b9a4ff0a5.patch?full_index=1"
    sha256 "64df1d1146d83f333d0caf45cb8a82288338761534dd0e0758a71132ca93a00b"
    type :backport
    resolves "https://github.com/lavv17/lftp/pull/776"
  end

  deny_network_access!

  def install
    # Fix compile with newer Clang
    # https://github.com/lavv17/lftp/issues/611
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}",
                          "--with-readline=#{formula_opt_prefix("readline")}",
                          "--with-libidn2=#{formula_opt_prefix("libidn2")}",
                          *std_configure_args

    system "make", "install"
  end

  test do
    (testpath/"src/hello.txt").write "hello from lftp"

    assert_match "hello.txt", shell_output("#{bin}/lftp -c 'open file:#{testpath}/src; ls'")

    system bin/"lftp", "-c", "open file:#{testpath}/src; mirror . #{testpath}/dst"
    assert_equal "hello from lftp", (testpath/"dst/hello.txt").read
  end
end
