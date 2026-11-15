class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.20/librist-v0.2.20.tar.gz"
  sha256 "9e40eeb87f014790531ad41326cc271b930a65962e4b15231b301fc59b29fe31"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c752266fb4814a60518c578a17fb741d637b3553c29880464ccae428af599181"
    sha256 cellar: :any, arm64_tahoe:       "d53fe875d0331485ee81cf492045ba8cf5551e596299104fc428666bdd328a8d"
    sha256 cellar: :any, arm64_sequoia:     "eb3efefc1292c5e105f3fa8e585d229a5cd9b853f97603acbbe26445faafe342"
    sha256 cellar: :any, arm64_linux:       "301e312087c08d893a3f6fe428932d134059d10d6d1b25c9060f2f982e892bb2"
    sha256 cellar: :any, x86_64_linux:      "0307064edb0c463e4c4fad1649dfd2de9eaf6faf1863a91fe6e45abf5e290564"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "libmicrohttpd"
  depends_on "lz4"
  depends_on "nettle"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    # Use gnutls as it is already a dependency via libmicrohttpd.
    # Also aligns with Debian and Fedora.
    args = %w[
      --default-library=both
      -Dfallback_builtin=false
      -Duse_nettle=true
      -Duse_mbedtls=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
