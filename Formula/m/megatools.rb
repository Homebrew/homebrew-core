class Megatools < Formula
  desc "Command-line client for Mega.co.nz"
  homepage "https://megatools.megous.com/"
  url "https://megatools.megous.com/builds/megatools-1.11.1.20230212.tar.gz"
  sha256 "ecfa2ee4b277c601ebae648287311030aa4ca73ea61ee730bc66bef24ef19a34"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url "https://megatools.megous.com/builds/"
    regex(/href=.*?megatools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4200cf8a8f115676b3ac6f0f1468003990e648a9cd5c08ce446e0528a1e363cc"
    sha256 cellar: :any, arm64_ventura:  "8a544fd3800af543d1928e51ce2406ef64d67e939bdf57b85cc79ebedd913d25"
    sha256 cellar: :any, arm64_monterey: "a74d719b8acca7b739308db2128e7d2641da8c42f38f7a9581c382b04bd19677"
    sha256 cellar: :any, arm64_big_sur:  "1317cfb8187d51dcf9f7b006a2ee45e1420786ad8a816c5a0b6726189d4aea93"
    sha256 cellar: :any, sonoma:         "9613c38ca9f50b37c0fb4451c60e27006d5dbcec559f7d4337f32425e7f907d6"
    sha256 cellar: :any, ventura:        "41fb9f67d057d8d34c121d23bc4fbcd8245cd0fa2c2cb26b069db0782f761e7b"
    sha256 cellar: :any, monterey:       "128619776dc719c748b2488c9f731b941cc11b105d8616abc4339160e02c28e6"
    sha256 cellar: :any, big_sur:        "329cfe785998411d902b0775f4144ad9adfcfd625775ffad3558ed899fe2497c"
    sha256               x86_64_linux:   "cb6a38119d2342ef36ee09e5b0c1dd98e6156e06aedfb8bb9b11a710678382b0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "openssl@3"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Downloads a publicly hosted file and verifies its contents.
    system "#{bin}/megadl",
      "https://mega.co.nz/#!3Q5CnDCb!PivMgZPyf6aFnCxJhgFLX1h9uUTy9ehoGrEcAkGZSaI",
      "--path", "testfile.txt"
    assert_equal File.read("testfile.txt"), "Hello Homebrew!\n"
  end
end
