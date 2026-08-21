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
    sha256 cellar: :any, arm64_tahoe:   "2bf5965a57d45f6fa801e28e7b18caec07d6db79586d4ed28d7c8ee51b13616a"
    sha256 cellar: :any, arm64_sequoia: "dab9d26eca067de86cbd69f942b3cfd2fce397970c79f98e8e2b813034c7b2db"
    sha256 cellar: :any, arm64_sonoma:  "19536d9cc3ce0a91b17722d372b3e9b4d53db6d48b55348ef9bfe01a52eafaa0"
    sha256 cellar: :any, sonoma:        "555f06010db118538bbef4667a69acf3dd52806fd9dfe20ccd22369094c1cc0d"
    sha256               arm64_linux:   "a3a7fc1abcf0a8bb68fe40fe37eb99093685b40eee11add3a79e4f3d499c066d"
    sha256               x86_64_linux:  "38f79e8fe594818a830cae4f6a1596b1f26a41eebf1369605a55d20f7710f765"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "lz4"
  depends_on "mbedtls@3"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
