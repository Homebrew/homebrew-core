class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https://jedisct1.github.io/minisign/"
  url "https://github.com/jedisct1/minisign/archive/0.11.tar.gz"
  sha256 "74c2c78a1cd51a43a6c98f46a4eabefbc8668074ca9aa14115544276b663fc55"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4798596d748b11ca8b076b66c5488f1271dd8d1179937aea0b9a4734b7333176"
    sha256 cellar: :any,                 arm64_monterey: "0bd20aceb1c9a087bd7d3ff8fe157968696f8b0dda9f7be0b018f03df9f6ad03"
    sha256 cellar: :any,                 arm64_big_sur:  "faac66b2478afa78e0ced45c48c83ef727806322b77bd97037e58fcf1f158c0a"
    sha256 cellar: :any,                 ventura:        "7cba50523996a6c90d0c9d22fbd4f7303801f7e5f011e13ae552aa90cd7c58bc"
    sha256 cellar: :any,                 monterey:       "1fd0d2269db30eb0a550e74c47313c0dd0d1dabefeeca59cb89aca9cb7822074"
    sha256 cellar: :any,                 big_sur:        "718f2322f19aad89ddc5fececca9762aeb6718caca091059789085892e581911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e73c41864c4c168f096e9a6c8480ea85a1070736a9ac267c35414a09dea8a21"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libsodium"

  uses_from_macos "expect" => :test

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.txt").write "Hello World!"
    (testpath/"keygen.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -G
      expect -exact "Please enter a password to protect the secret key."
      expect -exact "\n"
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect -exact "\r
      Password (one more time): "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "keygen.exp"
    assert_predicate testpath/"minisign.pub", :exist?
    assert_predicate testpath/".minisign/minisign.key", :exist?

    (testpath/"signing.exp").write <<~EOS
      set timeout -1
      spawn #{bin}/minisign -Sm homebrew.txt
      expect -exact "Password: "
      send -- "Homebrew\n"
      expect eof
    EOS

    system "expect", "-f", "signing.exp"
    assert_predicate testpath/"homebrew.txt.minisig", :exist?
  end
end
