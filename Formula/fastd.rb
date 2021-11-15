class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/NeoRaider/fastd"
  url "https://github.com/NeoRaider/fastd.git",
      tag:      "v22",
      revision: "0f47d83eac2047d33efdab6eeaa9f81f17e3ebd1"
  license "BSD-2-Clause"
  head "https://github.com/NeoRaider/fastd.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e8c034f7725b6783bc9d811026120c2fe7730c8654da37b890e043654755e4a7"
    sha256 cellar: :any, arm64_big_sur:  "0c9a053904d99b504199894884c1bf8726d37a8d615e39f7241ca0288a1db48b"
    sha256 cellar: :any, monterey:       "80925ae137116b0dcbcafd7bad1adb273b2b73147eca8029914963e26d0667cd"
    sha256 cellar: :any, big_sur:        "80cb41c2885f7dea9a880de2a373f1643a9a204dcd1fbe7e865c7cb4fe2069f9"
    sha256 cellar: :any, catalina:       "b26819307ac8f58961adcb171eaffcbb06dc4758667aca30ce726befc861523c"
    sha256 cellar: :any, mojave:         "74193caa95dbb4e885eca705ce72b0fc3e708222e914448081752eee6c4051d9"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@1.1"

  # remove in next release
  patch do
    url "https://github.com/NeoRaider/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
    sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
  end

  def install
    mkdir "build" do
      system "meson", "-Db_lto=true", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/fastd", "--generate-key"
  end
end
