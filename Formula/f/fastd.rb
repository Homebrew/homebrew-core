class Fastd < Formula
  desc "Fast and Secure Tunnelling Daemon"
  homepage "https://github.com/neocturne/fastd"
  url "https://github.com/neocturne/fastd.git",
      tag:      "v22",
      revision: "0f47d83eac2047d33efdab6eeaa9f81f17e3ebd1"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/neocturne/fastd.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "dec129faf709276bc51ace4b7f75b3c5ad0bd7054d16f6732e7d17af88d214dc"
    sha256 cellar: :any, arm64_sonoma:   "47546d8f19b4aa18516f976cd4da96dacc190ac1d29ed97724baed9240d4e8c9"
    sha256 cellar: :any, arm64_ventura:  "024b4441f467477b61a7ed9dbce3bb5eaae293a77131abd6293741679d122a77"
    sha256 cellar: :any, arm64_monterey: "5c53118d30669c0aafb1662819055f9c21e1344142f61a1219791c10ccf505ce"
    sha256 cellar: :any, sonoma:         "b7f218a850d3c7005c3fcca7387012fb5e97a8a442eb5fc2b4b2c130ac0bf0a9"
    sha256 cellar: :any, ventura:        "1d2c5e23e64ac443c0feb2d050d0a7312072a1d00452cb847f7c3e6a70a318c4"
    sha256 cellar: :any, monterey:       "091f3b642fdff66047b93c2a7266ba6b1879b43f125e69b6edeeb67e75d51848"
    sha256               x86_64_linux:   "9a66efcc168c33e8bfcb41ac843cac44e083d1eccc1fc024347dcc254f5faad0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "libuecc"
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "libmnl"
  end

  # remove in next release
  patch do
    url "https://github.com/neocturne/fastd/commit/89abc48e60e182f8d57e924df16acf33c6670a9b.patch?full_index=1"
    sha256 "7bcac7dc288961a34830ef0552e1f9985f1b818aa37978b281f542a26fb059b9"
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
