class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/neocturne/fastd"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/neocturne/fastd.git", branch: "main"

  stable do
    url "https://github.com/neocturne/fastd/releases/download/v23/fastd-23.tar.xz"
    sha256 "dcab54485c79dda22ce6308a2a48764d53977a518952facd1204ba21af1c86e0"

    # remove in next release
    patch do
      url "https://github.com/neocturne/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
      sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07d1fa9fdd6b0e6c1003db1de59d2e2f67336898787d755348a899215509f9cc"
    sha256 cellar: :any, arm64_sequoia: "8f4a44d8de63f43b4cf7af18de73f28a2a6505d6606b256ea0e79710019a06d0"
    sha256 cellar: :any, arm64_sonoma:  "e4af46b0285b50120e61b6c2442f3394fcba09b2e45eb66150680be05ab5819d"
    sha256 cellar: :any, sonoma:        "4db0e4671c04a3cb535c8a9063311ac6588c662f970c78d0cfbb00375efdb6a6"
    sha256               arm64_linux:   "f0bcd2483d044918fcb66f214b12efc99790b1e1f032d3fd47f7f49682ffcf3b"
    sha256               x86_64_linux:  "2ee7f0381a3b9007a0adb9f9083e145adc568dd47eb70dde9543e27189264f29"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@4"

  on_linux do
    depends_on "libcap"
    depends_on "libmnl"
  end

  def install
    system "meson", "setup", "build", "-Db_lto=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"fastd", "--generate-key"
  end
end
